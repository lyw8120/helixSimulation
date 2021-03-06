%parameters in Helix

BoxSizeInPixel = 300;
PixelSize = 1.32;                     %A/pixel
BoxSize = BoxSizeInPixel * PixelSize;   %Box size in A   
Rise = 4.73;                              %A, rise on Z axis for each subunit.
NumOfSubUnit = round(BoxSize/Rise);        %how many subunits, get the integer number.
CrossOverDistance = 680;                  %turn 180 degrees, how long in A around the Z axis
Twist = 180 / (CrossOverDistance / Rise);   %angle increase for each subunit. turn over 180, get one crossover.
Degrees = (NumOfSubUnit-1)*Twist;              % how many degree in total.
D = 100;                                 % out tube diameter in A.
if(D > BoxSize)
    disp("diameter is greater than the boxsize, exit.");
    return;
end
Handness = 1;      % 1: right handness, 0: left handness.


%initial the cooridinate file
x=(-D/2:4:D/2);
len = length(x);

%there are 4 peptide chains parallelly (4 chains fill the diameter)
%but on the pependicular direction, it about 0.8 * D filled.
%this derived from the paper of "Structure of the toxic core of a-synuclein from invisible crystals"
interdistance = 0.8*D/5;

y=zeros(1, len);
y(:) = interdistance/2;
y1 = y;
y(:) = 1.5 * interdistance;
y2 = y;
y(:) = -interdistance/2;
y3 = y;
y(:) = -interdistance * 1.5;
y4 = y;

z=zeros(1, len*4);

xy=[x',y1'; x', y2'; x', y3'; x', y4'];
Coors = [xy, z'];

if Handness == 0
    for i = 0:Twist:Degrees
        tmp = int32(i/Twist)+1;
        angle = double(i/180) * pi;
        tmp_xy = xy*[cos(angle), -sin(angle);sin(angle), cos(angle)];
        tmp_z = zeros(1,len*4);
        tmp_z(:) = Rise * tmp;
        tmp_coors = [tmp_xy,tmp_z'];
        Coors = [Coors;tmp_coors];
    end
else
    for i = 0:Twist:Degrees
        tmp = int32(i/Twist)+1;
        angle = -double(i/180) * pi;
        tmp_xy = xy*[cos(angle), -sin(angle);sin(angle), cos(angle)];
      %  tmp_z = zeros(1,len);
        tmp_z = zeros(1,len*4);
        tmp_z(:) = Rise * tmp;
        tmp_coors = [tmp_xy,tmp_z'];
        Coors = [Coors;tmp_coors];
    end
end 

%pdb file, need to be centered
Coors(:,3)=Coors(:,3)-Coors(round(rows(Coors)/2), 3);   


 
 scatter3(Coors(:,1),Coors(:,2),Coors(:,3))

 
fid = fopen('HelixCoors.txt', 'wt');
for i = 1:size(Coors,1)
    fprintf(fid, '%-0.4f \t', Coors(i,:));
    fprintf(fid, '\n');
end
fclose(fid);


%Create pdb file
Helixpdb = fopen('Helix.pdb','w');
fprintf(Helixpdb, '%-6s\t %-40s\n', 'HEADER', 'GENERATED by Octave script.');
fprintf(Helixpdb, '%-6s\t %-40s\n', 'AUTHOR', 'YAO-WANG LI');
fprintf(Helixpdb, '%-6s\n', 'HEADER');
 

% the e2pdb2mrc.py read 12:14, 6:11, 22:26, 30:38, 38:46,46:54
for i = 1:rows(Coors)
    fprintf(Helixpdb,'%-5s%6d%3s%6s%1c%5d    %-8.3f%-8.3f%-8.3f\n', 'ATOM', i, 'N', 'HIS', 'A', 1, Coors(i,1), Coors(i,2), Coors(i,3));
    fprintf(Helixpdb, '%-6s\n', 'TER');
end

fprintf(Helixpdb, '%-6s\n', 'END');
fclose(Helixpdb);



