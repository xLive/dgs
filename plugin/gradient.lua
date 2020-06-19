--[[
directions:
1- left to right
2- right to left
3- top to bottom
4- bottom to top
]]

function dgsCreateGradient(color1,color2,direction)
    assert(type(color1) == "number","Bad argument @dgsCreateGradient at argument 1, expect number got "..type(color1))
    assert(type(color2) == "number","Bad argument @dgsCreateGradient at argument 2, expect number got "..type(color2))
    local direction = tonumber(direction) and (tonumber(direction) >= 1 and tonumber(direction) <= 4) and tonumber(direction) or 1
    local shader = dxCreateShader([[bool vertical;
    float3 RGBFrom;
    float3 RGBTo;
    
    float4 gradientShader(float2 tex:TEXCOORD0,float4 color:COLOR0):COLOR0{
        float kValue = tex[!vertical];
        float3 rgb = RGBFrom+(RGBTo-RGBFrom)*kValue;
        color.rgb = rgb.xyz;
        return color;
    }
    
    technique Gradient{
        pass P0{
            PixelShader = compile ps_2_0 gradientShader();
        }
    }
    ]]
    )
    dgsSetData(shader,"asPlugin","dgs-dxgradient")
    dgsSetData(shader,"colors",{color1,color2})
    dgsSetData(shader,"direction",direction)
    dxSetShaderValue(shader,"RGBFrom",fromcolor((direction == 1 or direction == 3) and color1 or color2,true,true))
    dxSetShaderValue(shader,"RGBTo",fromcolor((direction == 2 or direction == 4) and color1 or color2,true,true))
    dxSetShaderValue(shader,"vertical",direction <= 2)
    triggerEvent("onDgsPluginCreate",shader,sourceResource)
    return shader 
end

function dgsGradientSetColors(gradShader,color1,color2)
    assert(dgsGetPluginType(gradShader) == "dgs-dxgradient","Bad argument @dgsGradientSetColors at argument 1, expect dgs-dxgradient got "..type(gradShader))
    assert(type(color1) == "number","Bad argument @dgsGetGradientColors at argument 2, expect number got "..type(color1))
    assert(type(color2) == "number","Bad argument @dgsGetGradientColors at argument 3, expect number got "..type(color2))
    local direction = dgsGetData(gradShader,"direction")
    dgsSetData(gradShader,"colors",{color1,color2})
    dxSetShaderValue(gradShader,"RGBFrom",fromcolor((direction == 1 or direction == 3) and color1 or color2,true,true))
    dxSetShaderValue(gradShader,"RGBTo",fromcolor((direction == 2 or direction == 4) and color1 or color2,true,true))
    return true 
end

function dgsGradientGetColors(gradShader,direction)
    assert(dgsGetPluginType(gradShader) == "dgs-dxgradient","Bad argument @dgsGradientGetColors at argument 1, expect dgs-dxgradient got "..type(gradShader))
    return unpack(dgsGetData(gradShader,"colors"))
end

function dgsGradientSetDirection(gradShader,direction)
    assert(dgsGetPluginType(gradShader) == "dgs-dxgradient","Bad argument @dgsGradientSetDirection at argument 1, expect dgs-dxgradient got "..type(gradShader))
    local direction = tonumber(direction) and (tonumber(direction) >= 1 and tonumber(direction) <= 4) and tonumber(direction) or 1
    local color1,color2 = unpack(dgsGetData(gradShader,"colors"))
    dgsSetData (gradShader,"direction",direction)
    dxSetShaderValue(gradShader,"RGBFrom",fromcolor((direction == 1 or direction == 3) and color1 or color2,true,true))
    dxSetShaderValue(gradShader,"RGBTo",fromcolor((direction == 2 or direction == 4) and color1 or color2,true,true))
    dxSetShaderValue(gradShader,"vertical",direction <= 2)
    return true 
end

function dgsGradientGetDirection(gradShader)
    assert(dgsGetPluginType(gradShader) == "dgs-dxgradient","Bad argument @dgsGradientGetDirection at argument 1, expect dgs-dxgradient got "..type(gradShader))
    return dgsGetData(gradShader,"direction")
end

    