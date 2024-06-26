classdef indiv 
    %defines an individual with a position (x,y) and a grp (SIR)
    properties 
        pos = zeros(2);
        grp = 'S';
        maskWearer = 'N'
        sociability = 1;
    end 
    methods 
        function obj = set.pos(obj, vpos)
            obj.pos = vpos; 
        end 
        function obj = set.grp(obj, ingrp)
            obj.grp = ingrp; 
        end 
        function value = getPos(obj)
            disp("getting pos")
            value = obj.pos;
        end
    end 
end