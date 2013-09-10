//
//  SCVParser.m
//  StateChartVisualizer
//
//  Created by Jerry Hsu on 9/8/13.
//  Copyright (c) 2013 GameChanger. All rights reserved.
//

#import "SCVParser.h"

@interface SCVParser() <CPTokeniserDelegate, CPParserDelegate>

@property (nonatomic, strong, readwrite) SCVStatechart* statechart;
@property (nonatomic, strong) NSMutableDictionary* stateMap;
@property (nonatomic, strong) NSMutableArray* transitions;

//- (SCVState *)rootStateForStateRepresentation:(NSString *)stateString error:(NSError *__autoreleasing *)error;

@end

@implementation SCVParser

- (id) init {
    self = [super init];
    if ( self ) {
        self.stateMap = [[NSMutableDictionary alloc] init];
        self.transitions = [[NSMutableArray alloc] init];

        self.statechart = [[SCVStatechart alloc] init];
        self.statechart.rootState = [[SCVState alloc] init];
        self.statechart.rootState.name = @"root";
        self.stateMap[@"root"] = self.statechart.rootState;
    }
    return self;
}

- (BOOL)parseStateRepresentation:(NSString *)stateString error:(NSError *__autoreleasing *)error {
    CPTokenStream* tokenStream = [self.tokeniser tokenise: stateString];
    //    NSLog(@"TokenStream %@", tokenStream);
    id result = [self.parser parse: tokenStream];
    NSLog(@"Parser %@", result);
    return YES;
}

#pragma mark - getter

- (CPTokeniser *)tokeniser {
    if ( _tokeniser == nil ) {
        CPTokeniser* tokeniser = [[CPTokeniser alloc] init];
        [tokeniser addTokenRecogniser: [CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
        [tokeniser addTokenRecogniser: [CPQuotedRecogniser quotedRecogniserWithStartQuote: @"(" endQuote: @")" name: @"stateName"]];
        [tokeniser addTokenRecogniser: [CPQuotedRecogniser quotedRecogniserWithStartQuote: @"[" endQuote: @"]" name: @"transitionName"]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @"{"]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @"}"]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @","]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @";"]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @"->"]];
        [tokeniser addTokenRecogniser: [CPKeywordRecogniser recogniserForKeyword: @":"]];
        tokeniser.delegate = self;

        _tokeniser = tokeniser;
    }
    return _tokeniser;
}

- (CPParser *)parser {
    if ( _parser == nil ) {
        NSString* expressionGrammar =
        @"Statechart ::= sentences@<Sentences> ;\n"
        @"Sentences ::= sentences@<Sentences> sentence@<Sentence> | sentence@<Sentence> ;\n"
        @"Sentence  ::= substateList@<SubstateList> ';' | transitionList@<TransitionList> ';' ;\n"
        @"SubstateList ::= stateName@'stateName' '{' substates@<Substates> '}' ;\n"
        @"Substates ::= substates@<Substates> ',' stateName@'stateName' | stateName@'stateName' ;\n"
        @"Transition ::= '->' | transitionName@'transitionName' '->' ;\n"
        @"TransitionList ::= sourceStateName@'stateName' transition@<Transition> targetStateName@'stateName';\n";
        NSError* err;
        CPGrammar* grammar = [CPGrammar grammarWithStart: @"Statechart" backusNaurForm: expressionGrammar error: &err];
        if ( nil == grammar ) {
            NSLog(@"Error creating grammar:");
            NSLog(@"%@", err);
        } else {
            CPParser* parser = [CPLALR1Parser parserWithGrammar: grammar];
            parser.delegate = self;
            _parser = parser;
        }
    }
    return _parser;
}

#pragma mark - CPTokeniserDelegate

- (BOOL)tokeniser:(CPTokeniser *)tokeniser shouldConsumeToken:(CPToken *)token {
    return YES;
}

- (void)tokeniser:(CPTokeniser *)tokeniser requestsToken:(CPToken *)token pushedOntoStream:(CPTokenStream *)stream {
    if ( ! [token isWhiteSpaceToken] && ![[token name] isEqualToString:@"Comment"] ) {
        [stream pushToken: token];
    }
}

#pragma mark - CPParserDelegate

- (id)parser:(CPParser *)parser didProduceSyntaxTree:(CPSyntaxTree *)syntaxTree {
//    NSLog(@"syntaxTree %@: %@", syntaxTree.rule.name, syntaxTree);
    if ( [syntaxTree.rule.name isEqualToString: @"Substates"] ) {
        NSMutableArray* substateList;
        if ( [syntaxTree.children count] == 1 ) {
            substateList = [[NSMutableArray alloc] init];
            [substateList addObject: [self stateForStateName: [[syntaxTree childAtIndex: 0] content]]];
        } else {
            substateList = [syntaxTree childAtIndex: 0];
            [substateList addObject: [self stateForStateName: [[syntaxTree childAtIndex: 2] content]]];
        }
        return substateList;
    } else if ( [syntaxTree.rule.name isEqualToString: @"SubstateList"] ) {
        SCVState* state = [self stateForStateName: [[syntaxTree childAtIndex: 0] content]];
        state.subStates = [[NSSet alloc] initWithArray: [syntaxTree childAtIndex: 2]];
        NSLog(@"parsed substatelist for state %@ substates %@", state, state.subStates);
    } else if ( [syntaxTree.rule.name isEqualToString: @"Transition"] ) {
        SCVTransition* transition = [[SCVTransition alloc] init];
        if ( [syntaxTree.children count] ==  2 ) {
            transition.name = [[syntaxTree childAtIndex: 0] content];
        }
        return transition;
    } else if ( [syntaxTree.rule.name isEqualToString: @"TransitionList"] ) {
        SCVTransition* transition = [syntaxTree childAtIndex: 1];
        transition.sourceState = [self stateForStateName: [[syntaxTree childAtIndex: 0] content]];
        transition.targetState = [self stateForStateName: [[syntaxTree childAtIndex: 2] content]];
        NSLog(@"parsed transition %@", transition);
        [self.transitions addObject: transition];
    } else if ( [syntaxTree.rule.name isEqualToString: @"Statechart"] ) {
        self.statechart.transitions = self.transitions;
        return self.statechart;
    }
    return syntaxTree;
}

- (SCVState*) stateForStateName: (NSString*) stateName {
    NSString* stateKey = [stateName lowercaseString];
    SCVState* ret = self.stateMap[stateKey];
    if ( ret == nil ) {
        ret = [[SCVState alloc] init];
        ret.name = stateName;
        self.stateMap[stateKey] = ret;
    }
    return ret;
}

@end
