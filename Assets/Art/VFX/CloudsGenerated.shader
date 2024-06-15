Shader "CloudGenerated"
{
    Properties
    {
        _Speed("Speed", Float) = 0.1
        _Noise_Scale("Noise Scale", Float) = 0
        _Base_Speed("Base Speed", Float) = 1
        _Base_Scale("Base Scale", Float) = 5
        _Base_Strength("Base Strength", Float) = 1
        _Color_Peak("Color Peak", Color) = (0, 0, 0, 0)
        _Color_Valley("Color Valley", Color) = (1, 1, 1, 0)
        _Emission_Strength("Emission Strength", Float) = 2
        _Size("Size", Float) = 100
        _Noise_Edge_1("Noise Edge 1", Float) = 1
        _Noise_Edge_2("Noise Edge 2", Float) = 1
        _Noise_Power("Noise Power", Float) = 2
        _Noise_Remap("Noise Remap", Vector) = (0, 0, 0, 0)
        _Rotate_Projection("Rotate Projection", Vector) = (0, 0, 0, 0)
        _Curvature_radius("Curvature radius", Float) = 1000
        _Fresnel_Power("Fresnel Power", Float) = 1
        _Fresnel_Opacity("Fresnel Opacity", Float) = 0
        _Fade_Depth("Fade Depth", Float) = 100
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 fogFactorAndVertexLight : INTERP5;
             float3 positionWS : INTERP6;
             float3 normalWS : INTERP7;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4 = _Color_Valley;
            float4 _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4 = _Color_Peak;
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float4 _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4;
            Unity_Lerp_float4(_Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4, _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxxx), _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4);
            float _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float);
            float _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float;
            Unity_Multiply_float_float(_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float, _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float);
            float _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float = _Fresnel_Opacity;
            float _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float, _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float, _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float);
            float4 _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4, (_Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float.xxxx), _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4);
            float _Property_b863dccc42894bfcba5deff255d06279_Out_0_Float = _Emission_Strength;
            float4 _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4, (_Property_b863dccc42894bfcba5deff255d06279_Out_0_Float.xxxx), _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4);
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.BaseColor = (_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4.xyz);
            surface.Metallic = 0;
            surface.Smoothness = 0.5;
            surface.Occlusion = 1;
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP3;
            #endif
             float4 tangentWS : INTERP4;
             float4 fogFactorAndVertexLight : INTERP5;
             float3 positionWS : INTERP6;
             float3 normalWS : INTERP7;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4 = _Color_Valley;
            float4 _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4 = _Color_Peak;
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float4 _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4;
            Unity_Lerp_float4(_Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4, _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxxx), _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4);
            float _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float);
            float _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float;
            Unity_Multiply_float_float(_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float, _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float);
            float _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float = _Fresnel_Opacity;
            float _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float, _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float, _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float);
            float4 _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4, (_Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float.xxxx), _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4);
            float _Property_b863dccc42894bfcba5deff255d06279_Out_0_Float = _Emission_Strength;
            float4 _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4, (_Property_b863dccc42894bfcba5deff255d06279_Out_0_Float.xxxx), _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4);
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.BaseColor = (_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4.xyz);
            surface.Metallic = 0;
            surface.Smoothness = 0.5;
            surface.Occlusion = 1;
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
             float3 normalWS : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4 = _Color_Valley;
            float4 _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4 = _Color_Peak;
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float4 _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4;
            Unity_Lerp_float4(_Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4, _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxxx), _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4);
            float _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float);
            float _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float;
            Unity_Multiply_float_float(_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float, _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float);
            float _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float = _Fresnel_Opacity;
            float _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float, _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float, _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float);
            float4 _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4, (_Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float.xxxx), _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4);
            float _Property_b863dccc42894bfcba5deff255d06279_Out_0_Float = _Emission_Strength;
            float4 _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4, (_Property_b863dccc42894bfcba5deff255d06279_Out_0_Float.xxxx), _Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4);
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.BaseColor = (_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4.xyz);
            surface.Emission = (_Multiply_06d6027a4d6a4064aa02714ae9c88850_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Speed;
        float _Noise_Scale;
        float _Base_Speed;
        float _Base_Scale;
        float _Base_Strength;
        float4 _Color_Peak;
        float4 _Color_Valley;
        float _Emission_Strength;
        float _Size;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float4 _Noise_Remap;
        float4 _Rotate_Projection;
        float _Curvature_radius;
        float _Fresnel_Power;
        float _Fresnel_Opacity;
        float _Fade_Depth;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float);
            float _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float = _Curvature_radius;
            float _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float;
            Unity_Divide_float(_Distance_da0d8b071dc94f63bc142c8807144bb8_Out_2_Float, _Property_5f8cbc3bb53f47dfa5f48506d6171857_Out_0_Float, _Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float);
            float _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float;
            Unity_Power_float(_Divide_bd84262d29e24f8090e269cdf3addf4c_Out_2_Float, 3, _Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float);
            float3 _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_6aaa02f1f14c4b8a876fd1ad23cae737_Out_2_Float.xxx), _Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3);
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float3 _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxx), _Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3);
            float _Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float = _Size;
            float3 _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_6fb32f98e435427ca48f501f60254c5b_Out_2_Vector3, (_Property_8fd87a2ab64e47798aeecc1c1bb46a89_Out_0_Float.xxx), _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3);
            float3 _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_018bdaa7724d47f7a3b9c1d92cb88781_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3);
            float3 _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            Unity_Add_float3(_Multiply_da98631220d94d6d98c2c7e842713e7c_Out_2_Vector3, _Add_cba84c5e812f442e82841dbd3612a20c_Out_2_Vector3, _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3);
            description.Position = _Add_38a2a57df0f44247a5f9476f3a39417e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4 = _Color_Valley;
            float4 _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4 = _Color_Peak;
            float _Property_434eee386bce4dad86674aa515a982f1_Out_0_Float = _Noise_Edge_1;
            float _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float = _Noise_Edge_2;
            float4 _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4 = _Rotate_Projection;
            float _Split_8ce84587103e4966b19459d65176eb90_R_1_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[0];
            float _Split_8ce84587103e4966b19459d65176eb90_G_2_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[1];
            float _Split_8ce84587103e4966b19459d65176eb90_B_3_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[2];
            float _Split_8ce84587103e4966b19459d65176eb90_A_4_Float = _Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4[3];
            float3 _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_f33da73e6e114ca2bf8a35aec90d5a32_Out_0_Vector4.xyz), _Split_8ce84587103e4966b19459d65176eb90_A_4_Float, _RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3);
            float _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float = _Speed;
            float _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_34c7c527c7334f1ea20ddc5c673fbaf9_Out_0_Float, _Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float);
            float2 _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_63156efd4dbe473d884eadcd3586fcac_Out_2_Float.xx), _TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2);
            float _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float = _Noise_Scale;
            float _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_494103101eb84339aa6c765cb8ac04cd_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float);
            float2 _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2);
            float _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_392c1b5f76644312b7a91b3e5ff4344e_Out_3_Vector2, _Property_5db5cc99fbcf4aca89444b6ce07b3f1b_Out_0_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float);
            float _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float;
            Unity_Add_float(_GradientNoise_549716218616465aa34282cefba8259c_Out_2_Float, _GradientNoise_cfa6de65afd14c2186d6a319d786fb7b_Out_2_Float, _Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float);
            float _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float;
            Unity_Divide_float(_Add_6534de0c25624483a0e93e09de4fab3c_Out_2_Float, 2, _Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float);
            float _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float;
            Unity_Saturate_float(_Divide_d147ece72ed842e5adce04cbc15353d9_Out_2_Float, _Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float);
            float _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float = _Noise_Power;
            float _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float;
            Unity_Power_float(_Saturate_4db7436a42214672b3782433673d58f3_Out_1_Float, _Property_132aa32b6d304776b1e1c5393cde113a_Out_0_Float, _Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float);
            float4 _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4 = _Noise_Remap;
            float _Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[0];
            float _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[1];
            float _Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[2];
            float _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float = _Property_83308eaa9c4b4b2981d41fc7097f5ab5_Out_0_Vector4[3];
            float4 _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4;
            float3 _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3;
            float2 _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_R_1_Float, _Split_d7b74bdf4d0942a280d1c50938762686_G_2_Float, 0, 0, _Combine_e68158069dd04393a3b0469446b80da3_RGBA_4_Vector4, _Combine_e68158069dd04393a3b0469446b80da3_RGB_5_Vector3, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2);
            float4 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4;
            float3 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3;
            float2 _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2;
            Unity_Combine_float(_Split_d7b74bdf4d0942a280d1c50938762686_B_3_Float, _Split_d7b74bdf4d0942a280d1c50938762686_A_4_Float, 0, 0, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGBA_4_Vector4, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RGB_5_Vector3, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2);
            float _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float;
            Unity_Remap_float(_Power_8e2a8c61e2d548bbaa60d85fa4e739f5_Out_2_Float, _Combine_e68158069dd04393a3b0469446b80da3_RG_6_Vector2, _Combine_fd241c7ccb5d4f228bafee25661c87e0_RG_6_Vector2, _Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float);
            float _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float;
            Unity_Absolute_float(_Remap_5359a9bff09d434eb4c4a3afd6c2332a_Out_3_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float);
            float _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float;
            Unity_Smoothstep_float(_Property_434eee386bce4dad86674aa515a982f1_Out_0_Float, _Property_b16c133a6f4841209ca923bb5f1f79a7_Out_0_Float, _Absolute_a9077968ad4d4156ae8e7c937eeef939_Out_1_Float, _Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float);
            float _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float = _Base_Speed;
            float _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_0497d15906bf4c6ca338a0c9b221559d_Out_0_Float, _Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float);
            float2 _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_48afc345470f4001b65fa5d666b0702c_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_bffa9f998d85413eb44d13c40f24b0f8_Out_2_Float.xx), _TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2);
            float _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float = _Base_Scale;
            float _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7d4273f050814c1c8b3db7f740cc12da_Out_3_Vector2, _Property_438e86626d0e4ced8c30d207274c2fc7_Out_0_Float, _GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float);
            float _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float = _Base_Strength;
            float _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ec86a9675cfa42f489ea49da0859ad05_Out_2_Float, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float);
            float _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float;
            Unity_Add_float(_Smoothstep_c0af4b42900a44a19a3311395cea433e_Out_3_Float, _Multiply_19ce545f884a464481c53a222599b752_Out_2_Float, _Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float);
            float _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float;
            Unity_Add_float(1, _Property_a8c759fccf0744a5be76bf3355144111_Out_0_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float);
            float _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float;
            Unity_Divide_float(_Add_ba336347ee784300932dab6e3c51ec7b_Out_2_Float, _Add_047baac656aa4610b3c3d5415c2d5434_Out_2_Float, _Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float);
            float4 _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4;
            Unity_Lerp_float4(_Property_8850c7abf6c445dc9f1d725094bd5274_Out_0_Vector4, _Property_e4e844816b794dac8851262eca3f31cb_Out_0_Vector4, (_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float.xxxx), _Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4);
            float _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float = _Fresnel_Power;
            float _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_b743b1914b294d16b9be6101d81193dc_Out_0_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float);
            float _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float;
            Unity_Multiply_float_float(_Divide_f4e1bac73e7e4d00aae890ed6507a56d_Out_2_Float, _FresnelEffect_0ee4176e9e7f4efd8776db793aaf6e96_Out_3_Float, _Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float);
            float _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float = _Fresnel_Opacity;
            float _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_11c48ed7d37345708916c1ef2b1a4fa8_Out_2_Float, _Property_830dc3bd226347e08d308b2ac4a8bd1d_Out_0_Float, _Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float);
            float4 _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4;
            Unity_Add_float4(_Lerp_4fa2697b97694290b120c36b59d90121_Out_3_Vector4, (_Multiply_fe248c77a492434daa723b1a3a2f6714_Out_2_Float.xxxx), _Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4);
            float _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float);
            float4 _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_R_1_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[0];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_G_2_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[1];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_B_3_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[2];
            float _Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float = _ScreenPosition_85af8b87ae1b4b90a4cb8c80dbda4e6d_Out_0_Vector4[3];
            float _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float;
            Unity_Subtract_float(_Split_cd7164a3f4894560b4f5cf0caf05e603_A_4_Float, 1, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float);
            float _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_9b03fc87b1fc42b58e5ea6b08c03bfc0_Out_1_Float, _Subtract_6edd6b8593264e2185cabc48b7b6008e_Out_2_Float, _Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float);
            float _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float = _Fade_Depth;
            float _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float;
            Unity_Divide_float(_Subtract_a7e9850f35f041f8a51a55ba64b932f7_Out_2_Float, _Property_d8062fd68cdb4961b9ba91045cc3d274_Out_0_Float, _Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float);
            float _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            Unity_Saturate_float(_Divide_cc7067d8abfc4a6e92949dbfe60204a5_Out_2_Float, _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float);
            surface.BaseColor = (_Add_ed06e7cf64024a168a924a3d5aaebcdc_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_98254ffa28c849069e28763d39601582_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}