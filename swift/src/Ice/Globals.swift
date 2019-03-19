// **********************************************************************
//
// Copyright (c) 2003-2018 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

import IceObjc

// Factories are registed once, when this file is loaded
private let initialized: Bool = {
    ICEUtil.registerFactories(exception: ExceptionFactory.self,
                              connectionInfo: ConnectionInfoFactory.self,
                              endpointInfo: EndpointInfoFactory.self)
    return true
}()

public func initialize(args: StringSeq = [],
                       initData userInitData: InitializationData? = nil,
                       configFile: String? = nil) throws -> Communicator {
    // Ensure factories are initialized
    precondition(initialized)

    return try autoreleasepool {
        var initData = userInitData ?? InitializationData()

        //
        // Properties
        //
        if initData.properties == nil {
            let (props, _) = try Ice.createProperties()
            initData.properties = props
        }

        if configFile != nil {
            try initData.properties!.load(configFile!)
        }

        //
        // Logger
        //
        // precedence:
        // - initData.logger
        // - logger property
        // - C++ plugin loggers
        // - Swift logger
        if initData.logger == nil {
            if let props = initData.properties {
                // "Ice.UseSystemdJournal" The SystemD Journal is not supported
                let hasLoggerProperty = ["Ice.LogFile", "Ice.UseSyslog"].contains {
                    return !props.getProperty($0).isEmpty
                }

                // If no logger properties have been specified then use the Swift logger.
                // This logger may be overwritten by a logger plug-in during initialization
                if !hasLoggerProperty {
                    initData.logger = LoggerI()
                }
            }
        }

        var loggerP: ICELoggerProtocol?
        if let l = initData.logger {
            loggerP = l as? LoggerI ?? LoggerWrapper(handle: l)
        }

        let propsHandle = (initData.properties as! PropertiesI)._handle
        let handle = try ICEUtil.initialize(args,
                                            properties: propsHandle,
                                            logger: loggerP)

        //
        // Update initData.properties reference to point to the properties object
        // created by Ice::initialize.
        //
        initData.properties = PropertiesI(handle: handle.getProperties())

        //
        // Update initData.logger referecnce in case a C++ logger plug-in installed a different logger
        //
        loggerP = handle.getLogger()
        if let logger = loggerP as? Logger {
            initData.logger = logger
        } else if let objcLogger = loggerP as? ICELogger {
            initData.logger = objcLogger.assign(to: ObjcLoggerWrapper.self) { ObjcLoggerWrapper(handle: objcLogger) }
        }

        return CommunicatorI(handle: handle, initData: initData)
    }
}

public func createProperties(args: StringSeq? = nil, defaults: Properties? = nil) throws -> (Properties, StringSeq) {
    return try autoreleasepool {
        var remArgs: NSArray?
        let propertiesHandle = try ICEUtil.createProperties(args,
                                                            defaults: (defaults as? PropertiesI)?._handle,
                                                            remArgs: &remArgs)

        // swiftlint:disable force_cast
        return (PropertiesI(handle: propertiesHandle), remArgs as! StringSeq)
    }
}

public var currentEncoding: EncodingVersion {
    var encoding = EncodingVersion()
    ICEUtil.currentEncoding(major: &encoding.major, minor: &encoding.minor)
    return encoding
}

public func stringToIdentity(_ string: String) throws -> Identity {
    var name = NSString()
    var category = NSString()
    try ICEUtil.stringToIdentity(str: string, name: &name, category: &category)
    return Identity(name: name as String, category: category as String)
}

public func identityToString(identity: Identity, mode: ToStringMode = ToStringMode.Unicode) throws -> String {
    return try ICEUtil.identityToString(name: identity.name,
                                        category: identity.category,
                                        mode: mode.rawValue) as String
}

public let Encoding_1_0 = Protocol.Encoding_1_0
public let Encoding_1_1 = Protocol.Encoding_1_1

public func encodingVersionToString(_ encoding: EncodingVersion) -> String {
    return ICEUtil.encodingVersionToString(major: encoding.major, minor: encoding.minor)
}
