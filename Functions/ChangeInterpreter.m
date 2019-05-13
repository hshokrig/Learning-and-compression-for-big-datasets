function ChangeInterpreter(h,Interpreter)
% CHANGEINTERPRETER puts interpeters in figure h to Interpreter

% ChangeInterpreter(gcf,'Latex')

    TexObj = findall(h,'Type','Text');
    LegObj = findall(h,'Type','Legend');
    AxeObj = findall(h,'Type','Axes');  
    ColObj = findall(h,'Type','Colorbar');
    
    Obj = [TexObj;LegObj]; % Tex and Legend opbjects can be treated similar
    
    n_Obj = length(Obj);
    for i = 1:n_Obj
        Obj(i).Interpreter = Interpreter;
    end
    
    Obj = [AxeObj;ColObj]; % Axes and colorbar opbjects can be treated similar
    
    n_Obj = length(Obj);
    for i = 1:n_Obj
        Obj(i).TickLabelInterpreter = Interpreter;
    end
end