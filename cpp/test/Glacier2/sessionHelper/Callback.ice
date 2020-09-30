//
// Copyright (c) ZeroC, Inc. All rights reserved.
//

#pragma once

module Test
{

exception CallbackException
{
    double someValue;
    string someString;
}

interface CallbackReceiver
{
    void callback();

    void callbackEx();
}

interface Callback
{
    void initiateCallback(CallbackReceiver* proxy);

    void initiateCallbackEx(CallbackReceiver* proxy);

    void shutdown();
}

}
