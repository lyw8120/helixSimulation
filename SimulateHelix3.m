%parameters in Helix
BoxSizeInPixel = 2000;
PixelSize = 1.32;                     %A/pixel
BoxSize = BoxSizeInPixel * PixelSize;   %Box size in A   
Rise = 50;                              %A, rise on Z axis for each subunit.
NumOfSubUnit = round(BoxSize/Rise);        %how many subunits, get the integer number.
CrossOverDistance = 770;                  %turn 180 degrees, how long in A around the Z axis
Twist = 180 / (CrossOverDistance / Rise);   %angle increase for each subunit. turn over 180, get one crossover.
Degrees = (NumOfSubUnit-1)*Twist;              % how many degree in total.
D = 50;                                 % out tube diameter in A.
if(D > BoxSize)
    disp("diameter is greater than the boxsize, exit.");
    return;
end

x = zeros(1, NumOfSubUnit);
y = zeros(1, NumOfSubUnit);
z = zeros(1, NumOfSubUnit);

pi = 3.1415926;
for i = 0:Twist:Degrees
    tmp = int32(i/Twist)+1;
    angle = double(i/180) * pi;
    Amplitude = D/2;
    x(1,tmp) = Amplitude * cos(angle);
    y(1,tmp) = Amplitude * sin(angle);
    z(1,tmp) = (Rise * double(tmp));
end





scatter3(x,y,z)

