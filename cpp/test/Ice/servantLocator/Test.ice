//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

#pragma once

module Test
{

exception TestIntfUserException
{
}

exception TestImpossibleException
{
}

interface TestIntf
{
    void requestFailedException();
    void unknownUserException();
    void unknownLocalException();
    void unknownException();
    void localException();
    void userException();
    void stdException();
    void cppException();

    void unknownExceptionWithServantException();

    string impossibleException(bool throw);
    string intfUserException(bool throw);

    void asyncResponse();
    void asyncException();

    void shutdown();
}

interface TestActivation
{
    void activateServantLocator(bool activate);
}

}
