%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2019-present, Mahmoud Afifi
% York University, Canada
% Email: mafifi@eecs.yorku.ca - m.3afifi@gmail.com
%
% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree.
% All rights reserved.
%
%%
% Please cite the following work if this program is used:
% Mahmoud Afifi and Michael S. Brown. Sensor Independent Illumination 
% Estimation for DNN Models. In BMVC, 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
classdef scaleLayer < nnet.layer.Layer
    
    properties
        h
        N
    end
    
    properties (Learnable)
        C
    end
    
    methods
        function layer = scaleLayer(name,N,h)
            layer.Name = name;
            layer.Description = "Histogram Normalization Layer";
            layer.h = h;
            layer.N = N;
            layer.C = rand * sqrt(1/layer.N);
        end
        
        function Z = predict(layer, X)
            L = length(X(:))/(layer.h*layer.h);
            Z = reshape(X.*layer.C,[layer.h,layer.h,1,L]);
            clear L X
        end
        
        
        
        function [dLdX,dLdC] = backward(layer, X, Z, dLdZ, memory)
            dLdZ(isnan(dLdZ)) = 0;
            dLdX = reshape(layer.C .* dLdZ,size(X));
            dLdC = X .* dLdZ;
            dLdC = sum(dLdC(:));
            clear X dLdZ Z
        end
        
    end
end