% ADJ_MATRIX_GUI
% Opens a figure.  Double click to create a vertex. Single click to
% connect vertices.  Right click to delete vertices or edges.
function adj_matrix_gui(action)

if nargin == 0
    action = 'init'; %when programm is started case 'init' is called
end
 X=zeros(1);
 S=zeros(1);
 h = gco;    %handle of current object, last number on the screen
 
switch action
    case 'motion'     %case 'motion' called when drawing line between numbers
        line_h = getappdata(gcf,'motionline'); %defining drawn line as line_h
        pt = get(gca,'CurrentPoint');  %current postion of the cursor
        pt = pt(1,:);   %first row of the matrix conatining the x,y and z ccordinate
        xdata = get(line_h,'XData'); %getting beginning and ending x coordinate of the line
        ydata = get(line_h,'YData'); %getting beginning and ending y coordinate of the line
        xdata(2) = pt(1); %assigning x coordinate of cursor to end coordinate of line
        ydata(2) = pt(2); %assigning y coordinate of cursor to end coordinate of line
        set(line_h,'XData',xdata,'YData',ydata) %setting the new line
       
    case 'down' %
        button = get(gcf,'SelectionType');
        switch button
            case 'normal'
                
                fig = gcf;  %handle of current figure, plot window
                
                % First click
                if ~isappdata(fig, 'motionline') %check if current figure has value'motionline' and if 'motionline' is associated with fig
                    if isequal(get(h,'Type'),'text') %checks if type of the current object in the plot is text
                        pt = get(h,'Position'); %position of current object on the screen
                        hold on
                        line_h = plot(pt(1), pt(2),'b-.' ... %plotting the points on the screen
                            ,'EraseMode','normal');
                        setappdata(line_h,'startobj',h)    % Save start object
                        hold off
                        stack_text_on_top       %printing number on top
                        setappdata(fig,'motionline',line_h)
                        set(fig,'WindowButtonMotionFcn', 'adj_matrix_gui(''motion'')'); %executes the 'motion' case whenever the cursor is moved
                    end
                else
                    % Second click
                    line_h = getappdata(fig,'motionline');  %defining drawn line as line_h
                    
                    if isequal(get(gco,'Type'),'text')  %checks if current objects type in the plot is text
                        startobj = getappdata(line_h,'startobj'); %getting starting point of line_h
                        endobj = gco;
                        startpt = get(startobj,'Position'); %getting position of starting point
                        endpt = get(endobj,'Position'); %getting postion of end point
                        set(line_h,'XData',[startpt(1) endpt(1)] ... %setting x and y data of start an endpoint
                            ,'YData',[startpt(2) endpt(2)]);
                        I = round(str2double(get(startobj,'String'))); %getting string of start object and transfer to double
                        J = round(str2double(get(endobj,'String'))); %getting string of end object and transfer to double
                        Matrix = getappdata(gcf,'Matrix'); %transform matrix of current function
                       
                        Matrix(I,J) = Matrix(I,J)+1; %adding the values in the spots where the connections are made
                        Matrix(J,I) = Matrix(J,I)+1; %adding the values in the spots where the connections are made
                        setappdata(gcf,'Matrix',Matrix) %setting the new  Transform Matrix into the 'Matrix' of the function
                        setappdata(0,'Matrix',Matrix)
                        
                        Matrix
                        
                    else
                        delete(line_h) % if the end of the line is not on a number delete it
                    end
                    
                    rmappdata(gcf,'motionline') %removing the motion line
                    set(fig,'WindowButtonMotionFcn', '');%setting reaction back to move the cursor
                end
            case 'open'
                pt = get(gca,'CurrentPoint');
                pt = pt(1,:);
                hold on
                n = 1+length(findobj(get(gca,'Children'),'Type','text'));
                h = text(pt(1),pt(2),num2str(n) ...
                    ,'Color','r','FontWeight','bold');
                hold off
                if ~isappdata(gcf,'Matrix')
                    setappdata(gcf,'Matrix',[])
                    setappdata(0,'Matrix',[])
                end
                Matrix = getappdata(gcf,'Matrix');
                Matrix(n,n) = 0;
                setappdata(gcf,'Matrix',Matrix)
                setappdata(0,'Matrix',Matrix)
                Matrix
            case 'alt'
                switch get(gco,'Type')
                    case 'text'
                        n = round(str2double(get(gco,'String')));
                        pt = get(gco,'Position');
                        handles = get(gca,'Children');
                        for I=1:length(handles)
                            h = handles(I);
                            if isequal(get(h,'Type'),'text')
                                n2 = round(str2double(get(h,'String')));
                                if n2 > n
                                    set(h,'String',n2-1)
                                end
                            else
                                xdata = get(h,'XData');
                                ydata = get(h,'YData');
                                if (xdata(1) == pt(1) & ydata(1) == pt(2)) ...
                                        |  (xdata(2) == pt(1) & ydata(2) == pt(2))
                                    delete(h)
                                end
                            end
                        end
                        if isappdata(gcf,'Matrix')
                            Matrix = getappdata(gcf,'Matrix');
                            Matrix(n,:) = [];
                            Matrix(:,n) = [];
                            setappdata(gcf,'Matrix',Matrix)
                            setappdata(0,'Matrix',Matrix)
                            Matrix
                        end
                        delete(gco)
                    case 'line'
                        xdata = get(gco,'XData'); %getting x coordinates of beginning and end of the line
                        ydata = get(gco,'YData'); %getting y coordinates of beginning and end of the line
                        txt_h = findobj(get(gca,'Children'),'Type','text'); %graphics placeholder array
                        for K=1:length(txt_h)
                            h = txt_h(K);
                            pt = get(h,'Position');
                            if (xdata(1) == pt(1) & ydata(1) == pt(2))
                                I = round(str2double(get(h,'String')));
                            elseif (xdata(2) == pt(1) & ydata(2) == pt(2))
                                J = round(str2double(get(h,'String')));
                            end
                        end
                        if isappdata(gcf,'Matrix')
                            Matrix = getappdata(gcf,'Matrix');
                            h=gco;
                            S=get(h,'UserData');
                            Matrix(I,J) = Matrix(I,J)-S;
                            Matrix(J,I) = Matrix(J,I)-S;
                            setappdata(gcf,'Matrix',Matrix)
                            setappdata(0,'Matrix',Matrix)
                            Matrix
                        end
                        delete(gco)
                end % End object switch
        end % End button switch
    case 'keypress'
        ESC = 27;
        
        switch get(gcf,'CurrentCharacter')
            case ESC
                if isappdata(gcf,'motionline')
                    line_h = getappdata(gcf,'motionline');
                    delete(line_h)
                    
                    rmappdata(gcf,'motionline')
                end
                set(gcf,'WindowButtonMotionFcn', '');
        end
        
    case 'init'             %called when function is started
        fig = figure('BackingStore', 'on', 'IntegerHandle', 'off', 'Name', 'Adjacency Matrix' ...
            ,'NumberTitle', 'off', 'MenuBar', 'none', 'DoubleBuffer','on','units','normalized','outerposition',[0 0 1 1]);
        movegui(fig,'west');
        pushb=uicontrol(fig,'Style','pushbutton','string','Continue','position',[630 215 70 20],'callback',@generate);
          
        ax = axes('Position',[0.1 0.1 0.35 0.9]);
        axis(ax,'square')
        ax.ActivePositionProperty = 'position';
        title('Double click to create vertex. Single click to connect. Right click to delete')
        xlim([0 8]);
        ylim([0 8]);
        set(fig,'WindowButtonDownFcn', 'adj_matrix_gui(''down'')');
        set(fig,'KeyPressFcn','adj_matrix_gui(''keypress'')')
        
        %input fenster hier öfffnen lassen
    otherwise
        error(['Unknown - ' action])
        
     
end % End action switch

function stack_text_on_top
ax = gca;
handles = get(gca,'Children');
txt_h = findobj(handles,'Type','text');

set(gca,'Children',[txt_h; setdiff(handles,txt_h)])

end

%     function putinval(varargin)
%             
%      %opening new input value
%            f=figure('Name','Input values','NumberTitle', 'off');
%            movegui(f,'east') 
%            Matrix=getappdata(0,'Matrix')
%      %getting number of nodes and vertices
%      txt1=uicontrol(f,'Style','text','Position',[10 350 110 50],'String','Number of Nodes');
%      edt1=uicontrol(f,'Style','edit','Position',[120 380 65 25]);
%      txt2=uicontrol(f,'Style','text','Position',[10 300 110 50],'String','Number of Vertices');
%      edt2=uicontrol(f,'Style','edit','Position',[120 330 65 25]);
%      
%      pushb1=uicontrol(f,'Style','pushbutton','string','Continue','position',[450 7 70 20],'callback',@generate);
     
    
     %callback for input values
 function generate(varargin)
     
%            f=figure('Name','Input values','NumberTitle', 'off');
%             movegui(f,'east')
         
          Matrix=getappdata(0,'Matrix');
          [N,t]= size(Matrix); %number of nodes
          [M,t] = size(full(adjacency2incidence(Matrix))); %number of edges
                 
       
       
        
        %opening edit boxes for nodes and vertices
        for i= 1 : N
        text=uicontrol('Style','text','position',[650 730-((i*50)-50) 10 15],'string',i); %-190
        txt(i)=uicontrol('Style','text','Position',[660 695-((i*50)-50) 50 50],'String','Node'); %20
        
%         edit2(i)=uicontrol(f,'Style','edit','Position',[260 280-((i*50)-50) 65 25]);
        chkb2(i)=uicontrol('Style','radiobutton','Position',[780 720-((i*50)-50) 70 35],'String', 'Ground');%140
        edit1(i)=uicontrol('Style','edit','Position',[710 725-((i*50)-50) 65 25]); %70
        end
        
        for j= 1 : M
        text=uicontrol('Style','text','position',[950 730-((j*50)-50) 10 15],'string',j); %265 -145
        txt=uicontrol('Style','text','Position',[960 695-((j*50)-50) 50 50],'String','Vertice'); %275
        chkb1(j)=uicontrol('Style','radiobutton','Position',[1015 728-((j*50)-50) 70 20],'String', 'Resistor'); %330
        valres(j)=uicontrol('Style','edit','position',[1080 725-((j*50)-50) 65 25]); %395
        
        end
        
        if j>i
            pushb2=uicontrol('Style','pushbutton','string','Finish','position',[835 680-((j*50)-50) 70 20],'callback',@finish);
        else
            pushb2=uicontrol('Style','pushbutton','string','Finish','position',[835 680-((i*50)-50) 70 20],'callback',@finish);
        end
      
        
     function [Pot,CurrentsN,V]=finish(varargin)
         
         CurrentsN=zeros(N,1);
           %getting current at certain nodes (no input=0)
           for i=1:N     
                           
            if isempty(get(edit1(i),'string'))
            else
            CurrentsN(i,1)=str2num(get(edit1(i),'string'));
            end
            
           end
           
           
        Pot=sym('q',[N,1]);
        %getting grounded potential rest becomes q
        for k=1:N           
                           
            if get(chkb2(k),'value')==1
            Pot(k)=0;
            else
            
            end
           
        end
       
        RMatrix=zeros(1,M);
        %getting Resistor values at the vertices
        for u=1:M
            if get(chkb1(u),'value')==1
            V(u)=str2num(get(valres(u),'string'));
            end
        end
        RMatrix=diag(V);
        
        Pot;
        RMatrix
        CurrentsN;
        AMatrix = Matrix
        IMatrix = full(adjacency2incidence(AMatrix))
        
        
        SMatrix = IMatrix'*inv(RMatrix)*IMatrix;
        k = find(Pot);
        Pot1 = SMatrix(k,k)*Pot(k);
        CurrentsN = CurrentsN(k);
        [A,B] = equationsToMatrix(Pot1, Pot(k));
        X = linsolve(A,CurrentsN);
        Pot(k)=X;
        
        textpotential=uicontrol('Style','text','position',[850 760 45 15],'string','Potential'); %-190

        for i= 1 : N
            Potential =char(Pot(i))
        textpot=uicontrol('Style','text','position',[855 730-((i*50)-50) 40 15],'string',Potential); %-190
        end
        
        U = IMatrix*Pot
        I = inv(RMatrix)*U
        
        textVoltage=uicontrol('Style','text','position',[1160 760 45 15],'string','Voltage');
        textCurrent=uicontrol('Style','text','position',[1230 760 45 15],'string','Current');
        
        for i= 1 : M
            Voltage =char(U(i));
            Current =char(I(i));
        textVoltage=uicontrol('Style','text','position',[1163 730-((i*50)-50) 40 15],'string',Voltage);
        textCurrent=uicontrol('Style','text','position',[1235 730-((i*50)-50) 40 15],'string',Current);
        end
        
     end
 end
end