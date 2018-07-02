% close any open figures
 close all;
 % create the helix data to plot
 varv=10;
 a = 0.05;
 c = 5.0;
 t = 0:0.01:varv*2*pi;
 x = (a*t/2*pi*c).*sin(t);
 y = (a*t/2*pi*c).*cos(t);
 z = t/(2*pi*c);
 % create a figure
 figure(3);
  % create the graphics object
 h = plot3(NaN,NaN,NaN);
 % label the axes
 xlabel('x');
 ylabel('y'); 
 zlabel('z');
 title('Conical helix');
  % set limits
 xlim([min(x) max(x)]);
 ylim([min(y) max(y)]);
 zlim([min(z) max(z)]);
 % plot the data
 for k=1:length(x)
    set(h,'XData',x(1:k),'YData',y(1:k),'ZData',z(1:k));
    pause(0.001);
 end