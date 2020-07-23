classdef Gamma 
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = public)
        alpha
        beta
        x_0
    end
    
    methods
        function obj = Gamma (alpha, beta, x_0)

            if nargin < 3
                x_0 = 0;
            end
            obj.alpha = alpha;
            obj.beta = beta;
            obj.x_0 = x_0;
            
        end
               
    end
end

