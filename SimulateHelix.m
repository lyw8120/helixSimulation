%parameters in Helix
BoxSizeInPixel = 1024;
PixelSize = 1.32;                     %A/pixel
BoxSize = BoxSizeInPixel * PixelSize;   %Box size in A   
Rise = 4.7;                              %A, rise on Z axis for each subunit.
NumOfSubUnit = round(BoxSize/Rise);        %how many subunits, get the integer number.
CrossOverDistance = 770;                  %turn 180 degrees, how long in A around the Z axis
Twist = 180 / (CrossOverDistance / Rise);   %angle increase for each subunit. turn over 180, get one crossover.
Degrees = (NumOfSubUnit-1)*Twist;              % how many degree in total.
D = 100;                                 % out tube diameter in A.
if(D > BoxSize)
    disp("diameter is greater than the boxsize, exit.");
    return;
end

x = zeros(1, NumOfSubUnit);
X = zeros(1, NumOfSubUnit);
y = zeros(1, NumOfSubUnit);
Y = zeros(1, NumOfSubUnit);
z = zeros(1, NumOfSubUnit);

pi = 3.1415926;
for i = 0:Twist:Degrees
    tmp = int32(i/Twist)+1;
    angle = double(i/180) * pi;
    ANGLE = (double(i/180)+1) * pi;
    Amplitude = D/2;
    x(1,tmp) = Amplitude * cos(angle);
    X(1,tmp) = Amplitude * cos(ANGLE);
    y(1,tmp) = Amplitude * sin(angle);
    Y(1,tmp) = Amplitude * sin(ANGLE);
    z(1,tmp) = (Rise * double(tmp));
end


dis = int32(sqrt((x(1,2)-X(1,2))^2 + (y(1,2)-Y(1,2))^2));
if (dis ~= D)
    disp("someting wrong, the tube diameter is not consistent.");
    return 
end



plot3(x,y,z)
hold on
plot3(X,Y,z)
hold off

