% A matlab code to recognize hand gesture by counting the number of fingers .
% string{1}='C:\Users\Admin\Desktop\Kin_pics\five2.png';
% string{2}='C:\Users\Admin\Desktop\Kin_pics\one.png';
% string{3}='C:\Users\Admin\Desktop\Kin_pics\three.png';
% string{4}='C:\Users\Admin\Desktop\Kin_pics\one.png';
% string{5}='C:\Users\Admin\Desktop\Kin_pics\four.png';
% string{6}='C:\Users\Admin\Desktop\Kin_pics\two.png';
% string{7}='C:\Users\Admin\Desktop\Kin_pics\four.png';

%start
vid=videoinput('kinect',1);
preview(vid);
pause;
ind=1;

num=0;sum=0;

while(1)
pause(5);

im=getsnapshot(vid);
% ind=1;
%arr(1:10,1:1)=zeros(1:10,1:1);
% num=0;sum=0;


img=imresize(im,[400 400]);

 imshow(img);
sz=size(img);
r=1;g=2;b=3;y=1;u=2;v=3;
yuv=img;
region=yuv;

for i=1:sz(1)
    for j=1:sz(2)
        yuv(i,j,y)=(img(i,j,r)+2*img(i,j,g)+img(i,j,b))/4;
        yuv(i,j,u)=img(i,j,r)-img(i,j,g);
        yuv(i,j,v)=img(i,j,b)-img(i,j,g);
    end
end

for i=1:sz(1)
    for j=1:sz(2)
        if yuv(i,j,u)>20 && yuv(i,j,u)<74
            region(i,j,r)=255;
            region(i,j,g)=255;
            region(i,j,b)=255;
        
        else
            region(i,j,r)=0;
            region(i,j,g)=0;
            region(i,j,b)=0;
        end
    end
end
% figure(13);imshow(yuv);
out=region;
% 
out=imfill(out,'holes');
out=imdilate(out,strel('square',3));
out=imfill(out,'holes');
% 
% figure(12);
% imshow(out);
%filtering
out=im2bw(out);
% out=imfill(out,'holes');
out=bwareaopen(out,1000);
% out=imfill(out,'holes');
out=imdilate(out,strel('diamond',2));
out=imfill(out,'holes');
% figure(14);imshow(out);
%retain largest only
res=out;
cc=bwconncomp(res);
arr=(cellfun('length',cc.PixelIdxList));

newLabel=res;
if ~isempty(round(arr))
    msz=0;
    for i=1:length(arr)
        if msz<arr(i:i)
            msz=arr(i:i);
            index=i;
        end
    end

    labels=labelmatrix(cc);
    newLabel=(labels==index);
    out=newLabel;
end
out=imfill(out,'holes');
im3=out;
% 
% figure(6);
% imshow(im3);
im3=imfill(im3,'holes');
% figure(7);
% imshow(im3);
% 
% title('Image with holes removed');
im4=bwareaopen(im3,10000);
% figure(8);
% imshow(im4);
% title('Removes objects less than 10000 pixels');
%Dhivin / HandGesture.m
%HandGesture.m
s1 = regionprops(im4,'Centroid');
centroids = cat(1, s1.Centroid);
% figure(9);
% imshow(im4);
% title('Centroid is found');
% hold(imgca,'on')
% plot(imgca,centroids(1), centroids(2), 'r*')
% hold(imgca,'off')
im8=bwmorph(im4,'thin',inf);
% figure(10);
% imshow(im8);
% title('Image is made infinitly thin');
[r,c]=size(im8);
for i=1:r
for j=1:c
if i>(centroids(2)-70)
im8(i,j)= 0;
end
end
end
% figure(11);
% imshow(im8);
[r c]=size(im8);
% title('Image bottom to the centroid is cutoff');
shank=im8;
pt=0;pt1=0;
[g h]=size(shank);
centroids(2)=uint16(centroids(2));
for i=1:h
if(shank((centroids(2)-70),i)==1)
    pt=pt+1;
    c_i=i;
end
if(shank((centroids(2)-71),i)==1)
    pt1=pt1+1;
    cc_i=i;
end
end

if(pt==0)
    pt=pt1;
    c_i=cc_i;
end

if(pt>9)
    pt1=0;
    for j=72:80
    for i=1:h
if(shank((centroids(2)-j),i)==1)
    pt1=pt1+1;
end

    end
    if(pt1<=9 && pt1~=0)
        pt=pt1;
        break;
    end
    end
end

disp('Number of fingers=');
disp(pt);

NET.addAssembly('System.Speech');
obj=System.Speech.Synthesis.SpeechSynthesizer;
obj.Volume=100;

% st=int2str(pt);
% Speak(obj,st);
color=1;%for numbers

if(pt==1)
    for j=72:(centroids(2)-10) 
        if(im4((centroids(2)-j),c_i)==0)
            c_j=centroids(2)-j;
            break;
        end
    end
%     disp(img(c_j-4,c_i,1));  
%     disp(img(c_j-4,c_i,2));
%     disp(img(c_j-4,c_i,3));

%checking for color
if img(c_j-4,c_i,1)>200 && img(c_j-4,c_i,2)>200 && img(c_j-4,c_i,3)>200
    color=1;%skin for one

elseif img(c_j-4,c_i,1)<40 && img(c_j-4,c_i,2)<40 && img(c_j-4,c_i,3)<40
    color=2;%black for plus
    pt=12;
    disp('+');
    %Speak(obj,'plus');
else
    
if img(c_j-4,c_i,1) > img(c_j-4,c_i,2) && img(c_j-4,c_i,1) > img(c_j-4,c_i,3)
    color=3;%red for minus
    pt=13;
    disp('-');
    %Speak(obj,'minus');
else
    if img(c_j-4,c_i,2) > img(c_j-4,c_i,1) && img(c_j-4,c_i,2) > img(c_j-4,c_i,3)
        color=4;%green for multiply
        pt=14;
        disp('*');
        %Speak(obj,'multiply');
    else
        color=5;%blue for stop
        
    end
end
%
end
%
end
%store numbers to perform BODMAS

if( color<5 && color>1)% if any signs
    %st=int2str(num);
    array(ind)=num;
 %   disp(array(ind));
    array(ind+1)=pt;
 %   disp(array(ind+1));
    ind=ind+2;
    num=0;
    %Speak(obj,st);
   % pause(0.5);
  
elseif(color==1)
    num=num*10+pt;
end
%numbers stored

% 
% array(ind)=num;
% st=int2str(num);
% Speak(obj,st);

%display(arr(ind));
%display array
% for i=1:ind
%     disp(array(i));
% end
%


if(color==5)
    
array(ind)=num;
% st=int2str(num);
% Speak(obj,st);

%display array
for i=1:ind
    if array(i)==12
        disp('+');
        Speak(obj,'plus');
    elseif array(i)==13
        disp('-');
        Speak(obj,'minus');
    elseif array(i)==14
        disp('*');
        Speak(obj,'multiply');
    else
    disp(array(i));
    st=int2str(array(i));
    Speak(obj,st);
    end
end
%
%multiply(14)   
for i=1:ind
    if(array(i)==14)
        array(i-1)=array(i-1)*array(i+1);
        for j=i:ind-2
            array(i)=array(i+2);
        end
        ind=ind-2;
    end
end 
%
%add(12) and subtract(13)
for i=1:ind
    if(array(i)==12)
        array(i-1)=array(i-1)+array(i+1);
        for j=i:ind-2
            array(i)=array(i+2);
        end
        ind=ind-2;
    
    else
        if(array(i)==13)
            array(i-1)=array(i-1)-array(i+1);
            for j=i:ind-2
                array(i)=array(i+2);
            end
            ind=ind-2;
        end
    end
    
end 
%
st=num2str(array(ind));

pause(0.5);
Speak(obj,'Answer equals');
display(array(ind));

Speak(obj,st);

break;%stop after result
end
%pause(0.5);
end