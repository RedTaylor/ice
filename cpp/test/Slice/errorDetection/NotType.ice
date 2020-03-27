//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

module Test
{

module Module1 { }
module Module2 { }
module Module3 { }
module Mod
{

sequence<Mod> Seq;
dictionary<int, Mod> Dict;
interface BarIntf : Mod { void op(); }
class BarClass1 : Mod { long l; }
class BarClass2 implements Module1, Module2, Module3 { long l; }
class BarClass3 : Mod implements Module1, Module2, Module3 { long l; }

}

exception E { }

struct S
{
    E e;
}

interface I
{
    E foo(E e1; E e2);
    void op();
}

}
