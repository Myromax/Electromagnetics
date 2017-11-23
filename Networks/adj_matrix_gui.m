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
                    if isequal(get(h,'Type'),'text') %checks if type of the numbers in the plot is text
                        pt = get(h,'Position'); %position of last number on the screen
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
                        
                        ESC = 27;
                        R = 114;
                        L = 108;
                        C = 99;
                        
                        switch get(gcf,'CurrentCharacter')
                            
                            case R
                                X=5;
                                
                            case L 
                                X=8;
                                
                            case C
                                X=10;
                                
                            otherwise X=1;
                        end
                        
                        a=findobj('Type','line');
                        
                        set(a,'UserData',X)
                                               
                        Matrix(I,J) = Matrix(I,J)+X; %adding the values in the spots where the connections are made
                        Matrix(J,I) = Matrix(J,I)+X; %adding the values in the spots where the connections are made
                        setappdata(gcf,'Matrix',Matrix) %setting the new  Transform Matrix into the 'Matrix' of the function
                        
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
                end
                Matrix = getappdata(gcf,'Matrix');
                Matrix(n,n) = 0;
                setappdata(gcf,'Matrix',Matrix)
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
                            a=findobj('Type','line');
                            S=get(a,'UserData');
                            Matrix(I,J) = Matrix(I,J)-S;
                            Matrix(J,I) = Matrix(J,I)-S;
                            setappdata(gcf,'Matrix',Matrix)
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
            ,'NumberTitle', 'off', 'MenuBar', 'none', 'DoubleBuffer','on');
        
        ax = axes;
        title('Double click to create vertex. Single click to connect. Right click to delete')
        xlim([0 10]);
        ylim([0 10]);
        set(fig,'WindowButtonDownFcn', 'adj_matrix_gui(''down'')');
        set(fig,'KeyPressFcn','adj_matrix_gui(''keypress'')')
    otherwise
        error(['Unknown - ' action])
end % End action switch

function stack_text_on_top
ax = gca;
handles = get(gca,'Children');
txt_h = findobj(handles,'Type','text');

set(gca,'Children',[txt_h; setdiff(handles,txt_h)])

