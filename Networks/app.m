function []=app(N)

%creating figure
f=figure('Visible','off');

%create text boxes and edit boxes for vertices, nodes and checkboxes
for i= 1 : N
txt(i)=uicontrol('Style','text','Position',[10 350-((i*50)-50) 50 50],'String','Node');
edt1(i)=uicontrol(f,'Style','edit','Position',[60 380-((i*50)-50) 65 25]);


end
button=uicontrol(f,'Style','pushbutton','string','save','position',[450 30 50 30],'callback',{@mycall});

    function mycall(varargin)
        voltin=zeros(N,1)
        for i=1:N
            voltin(i,1)=str2num(get(edt1(i),'string'));
        end
        voltin
    end



for j= 1 : N-1
txt=uicontrol('Style','text','Position',[130 335-((j*50)-50) 50 50],'String','vertices');  
edt2=uicontrol(f,'Style','edit','Position',[190 365-((j*50)-50) 65 25]);
chkb1=uicontrol('Style','radiobutton','Position',[260 385-((j*50)-50) 70 15],'String', 'Resistor');
chkb2=uicontrol('Style','radiobutton','Position',[260 370-((j*50)-50) 70 15],'String', 'Capacitor');
chkb3=uicontrol('Style','radiobutton','Position',[260 355-((j*50)-50) 70 15],'String', 'Inductor');
end


f.Visible='on';
end
