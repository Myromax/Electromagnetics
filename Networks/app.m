function [components,currentin, voltin]=app(N,M)

%creating figure
f=figure('Visible','off');
movegui(f,'east')

%create text boxes and edit boxes for vertices, nodes and checkboxes
for i= 1 : N
txt(i)=uicontrol('Style','text','Position',[10 350-((i*50)-50) 50 50],'String','Node');
edt1(i)=uicontrol(f,'Style','edit','Position',[60 380-((i*50)-50) 65 25]);
end

for j= 1 : M
txt=uicontrol('Style','text','Position',[130 350-((j*50)-50) 50 50],'String','vertices');  
edt2(j)=uicontrol(f,'Style','edit','Position',[190 380-((j*50)-50) 65 25]);
chkb1(j)=uicontrol('Style','radiobutton','Position',[260 400-((j*50)-50) 70 15],'String', 'Resistor');
valres(j)=uicontrol('Style','edit','position',[325 400-((j*50)-50) 70 15]);
chkb2(j)=uicontrol('Style','radiobutton','Position',[260 385-((j*50)-50) 70 15],'String', 'Capacitor');
valcap(j)=uicontrol('Style','edit','position',[325 385-((j*50)-50) 70 15]);
chkb3(j)=uicontrol('Style','radiobutton','Position',[260 370-((j*50)-50) 70 15],'String', 'Inductor');
valind(j)=uicontrol('Style','edit','position',[325 370-((j*50)-50) 70 15]);
end

%saving button +callback
button=uicontrol(f,'Style','pushbutton','string','save','position',[450 30 50 30],'callback',{@mycall});

    function mycall(varargin)
        voltin=zeros(N,1);
        currentin=zeros(M,1);
        components=zeros(1,M);
        
        %getting the elements on each vertice and its value
        for x=1:M
           n=get(chkb1(x),'Value')+get(chkb2(x),'Value')+get(chkb3(x),'Value');
         
           switch n
              
              case 1
                  if(get(chkb1(x),'Value')==1)
                      components(1,x)=str2num(get(valres(x),'string'))
                  elseif(get(chkb2(x),'Value')==1)
                      components(1,x)=str2num(get(valcap(x),'string'))
                  elseif(get(chkb3(x),'Value')==1)
                      components(1,x)=str2num(get(valind(x),'string'))
                  end
              case 2
                  if((get(chkb1(x),'value')==1)&&(get(chkb2(x),'value')==1))
                      components(1,x)=str2num(get(valres(x),'string'))+str2num(get(valcap(x),'string'));
                  elseif((get(chkb1(x),'value')==1)&&(get(chkb3(x),'value')==1))
                      components(1,x)=str2num(get(valres(x),'string'))+str2num(get(valind(x),'string'));
                  elseif((get(chkb2(x),'value')==1)&&(get(chkb3(x),'value')==1))
                      components(1,x)=str2num(get(valcap(x),'string'))+str2num(get(valind(x),'string'));
                  end
              case 3
                      components(1,x)=str2num(get(valres(x),'string'))+str2num(get(valcap(x),'string'))+str2num(get(valind(x),'string'));
              
           end
             
        end
        
      
        
        for i=1:N     
                            %getting input for voltages from edit boxes
            if isempty(get(edt1(i),'string'))
            else
            voltin(i,1)=str2num(get(edt1(i),'string'));
            end
        end
        
        for k=1:M           
                            %getting input for currents from edit boxes
            if isempty(get(edt2(k),'string'))
            else
            currentin(k,1)=str2num(get(edt2(k),'string'));
            end
        end
        
        
        uiresume;
    end
   
f.Visible='on';
end

