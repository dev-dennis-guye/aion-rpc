<#import "../java_macros.ftl" as macros/>
package org.aion.rpc.server;

import static org.aion.rpc.errors.RPCExceptions.*;

import java.math.BigInteger;
import java.util.*;
import org.aion.rpc.types.RPCTypes.*;
import org.aion.rpc.types.RPCTypesConverter.*;
import org.aion.types.AionAddress;
import org.aion.util.types.ByteArrayWrapper;
/******************************************************************************
*
* AUTO-GENERATED SOURCE FILE.  DO NOT EDIT MANUALLY -- YOUR CHANGES WILL
* BE WIPED OUT WHEN THIS FILE GETS RE-GENERATED OR UPDATED.
* GENERATED: ${date}
*
*****************************************************************************/
public interface RPCServerMethods extends RPC{
    /**
    *
    * @param request the client request
    * @param rpc the rpc implementation to be used in fulfilling this request.
    * @throws ${macros.toJavaException("InvalidParams")} if the parameters are not well formed
    * @throws ${macros.toJavaException("NullReturn")} if the specified method returns a null result
    * @throws ${macros.toJavaException("MethodNotFound")} if the requested method does not exist
    * @return the result of this request
    */
    static Object execute(Request request, RPCServerMethods rpc){
        Object res;
            //check that the request can be fulfilled by this class
            <#list methods as method>
            if(request.method.equals("${method.name}")){
                ${macros.toJavaType(method.param)} params= ${macros.toJavaConverter(method.param)}.decode(request.params);
                if (params==null) throw new ${macros.toJavaException("InvalidParams")}();
                ${macros.toJavaType(method.returnType)} result = rpc.${method.name}(<#list method.param.fields as parameter>params.${parameter.fieldName}<#if parameter_has_next>,</#if></#list>);
                // JSON RPC spec demands that if the result member does not exist
                // we should return an error see: https://www.jsonrpc.org/specification#response_object
                if (result == null ) throw new ${macros.toJavaException("NullReturn")}("Could not retrieve a result for ${method.name}");
                else res = ${macros.toJavaConverter(method.returnType)}.encode(result);
            }else
            </#list>
                throw new ${macros.toJavaException("MethodNotFound")}();
        return res;
    }

    /**
    * @return a set containing all the methods supported by this interface
    */
    static Set<String> listMethods(){
        return Set.of(<#list methods as method> "${method.name}"<#if method_has_next>,</#if></#list>);
    }

    <#list methods as method>
    /**
        <#if method.comments?has_content>
            <#list method.comments as comment>
    * ${comment}
            </#list>
        </#if>
    * <#if method.param.fields?has_content>
        <#list method.param.fields as parameter>
    * @param ${parameter.fieldName} <#list parameter.comments as comment>${comment}
    </#list>

    </#list>

    </#if>

    * @return <#if method.returnType.comments?has_content><#list method.returnType.comments as comment>${comment}
    </#list>
    </#if>

    */
    ${macros.toJavaType(method.returnType)} ${method.name}(<#list method.param.fields as parameter>${macros.toJavaType(parameter.type)} ${parameter.fieldName}<#if parameter_has_next>,</#if></#list>);
    </#list>

    /**
    * @return an map that stores the method names as the key and the interface(namespace) as the value.
    */
    static Map<String, String> methodInterfaceMap(){
        return Map.ofEntries(
    <#list methods as method>
            Map.entry("${method.name}", "${method.namespace}")<#if method_has_next>,</#if>
    </#list>
        );
    }

}
