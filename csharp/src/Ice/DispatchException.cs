//
// Copyright (c) ZeroC, Inc. All rights reserved.
//
using System;

namespace Ice
{
    // The partial classes below extend the partial exception classes generated by the Slice compiler.

    public partial class DispatchException
    {
        protected override string DefaultMessage
            => Facet.Length == 0 ? $"failed to dispatch request for operation `{Operation}' on Ice object `{Id}'"
                : $"failed to dispatch request for operation `{Operation}' on Ice object `{Id}' with facet `{Facet}'";
    }

    public partial class ObjectNotExistException
    {
        protected override string DefaultMessage
            => $"could not find servant for Ice object `{Id}'" + (Facet.Length > 0 ? $" with facet `{Facet}'" : "") +
                $" while attempting to dispatch operation `{Operation}'";
    }

    public partial class OperationNotExistException
    {
        protected override string DefaultMessage
            => $"could not find operation `{Operation}' for Ice object `{Id}'" +
                (Facet.Length > 0 ? $" with facet `{Facet}'" : "");
    }

    public partial class UnhandledException
    {
        public UnhandledException(Identity id, string facet, string operation, Exception innerException)
            : base(CustomMessage(id, facet, operation, innerException), id, facet, operation, innerException)
        {
        }

        private static string CustomMessage(Identity id, string facet, string operation, Exception innerException)
        {
            string message = $"unhandled exception while dispatching `{operation}' on Ice object `{id}'";
            if (facet.Length > 0)
            {
                message += $" with facet `{facet}'";
            }
#if DEBUG
            message += $":\n{innerException}\n---";
#else
            // Since this custom message will be sent "over the wire", we don't include the stack trace of the inner
            // exception since it can include sensitive information. The stack trace is of course available locally.
            message += $":\n{innerException.Message}";
#endif
            return message;
        }
    }
}
