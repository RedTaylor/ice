//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

#pragma once

module Test
{

exception Base
{
    string b;
}

exception KnownDerived : Base
{
    string kd;
}

exception KnownIntermediate : Base
{
    string ki;
}

exception KnownMostDerived : KnownIntermediate
{
    string kmd;
}

[preserve-slice]
exception KnownPreserved : Base
{
    string kp;
}

exception KnownPreservedDerived : KnownPreserved
{
    string kpd;
}

[preserve-slice]
class BaseClass
{
    string bc;
}

[format:sliced]
interface Relay
{
    void knownPreservedAsBase();
    void knownPreservedAsKnownPreserved();

    void unknownPreservedAsBase();
    void unknownPreservedAsKnownPreserved();
}

[format:sliced]
interface TestIntf
{
    void baseAsBase();
    void unknownDerivedAsBase();
    void knownDerivedAsBase();
    void knownDerivedAsKnownDerived();

    void unknownIntermediateAsBase();
    void knownIntermediateAsBase();
    void knownMostDerivedAsBase();
    void knownIntermediateAsKnownIntermediate();
    void knownMostDerivedAsKnownIntermediate();
    void knownMostDerivedAsKnownMostDerived();

    void unknownMostDerived1AsBase();
    void unknownMostDerived1AsKnownIntermediate();
    void unknownMostDerived2AsBase();

    [format:compact] void unknownMostDerived2AsBaseCompact();

    void knownPreservedAsBase();
    void knownPreservedAsKnownPreserved();

    void relayKnownPreservedAsBase(Relay* r);
    void relayKnownPreservedAsKnownPreserved(Relay* r);

    void unknownPreservedAsBase();
    void unknownPreservedAsKnownPreserved();

    void relayUnknownPreservedAsBase(Relay* r);
    void relayUnknownPreservedAsKnownPreserved(Relay* r);

    void shutdown();
}

}
