function [llrt_max,k_max]=changePointPar_final(x,y,z)
dx=diff(x);
dy=diff(y);
dz=diff(z);
N=length(dx);
stepSize=1000;


Do=sum((dx-mean(dx)).^2)/N+sum((dy-mean(dy)).^2)/N+sum((dz-mean(dz)).^2)/N;

underD1=zeros(1,1000);
overD2=zeros(1,1000);
% hF=figure;
% hold on;
% figureandaxiscolors('w','k');
% axis square;
% xlabel('k');
% ylabel('Z_n^1^/^2');
k_max=0;
llrt_max=0;
underOpt=1;
overOpt=1;
for j=1:ceil(N/stepSize)
    if j==ceil(N/stepSize)&&mod(N,stepSize)
        kRange=((j-1)*stepSize+1):N;
        stepSize= N-floor(N/stepSize)*stepSize;
        if j==1
            underOpt=0;
            overOpt=0;
        else
            underOpt=1;
            overOpt=0;
        end
    elseif ~mod(N,stepSize)
        kRange=((j-1)*stepSize+1):j*stepSize;
        underOpt=1;
        overOpt=0;
    else
        kRange=((j-1)*stepSize+1):j*stepSize;
        underOpt=1;
        overOpt=1;
    end
    upperWeights=triu(ones(stepSize,stepSize));
    lowerWeights=tril(ones(stepSize,stepSize),-1);
    
    
    largeDX=repmat(dx(kRange),1,stepSize);
    
    upperDX=triu(largeDX);
    lowerDX=tril(largeDX,-1);
    
    largeDY=repmat(dy(kRange),1,stepSize);
    upperDY=triu(largeDY);
    lowerDY=tril(largeDY,-1);
    
    largeDZ=repmat(dz(kRange),1,stepSize);
    upperDZ=triu(largeDZ);
    lowerDZ=tril(largeDZ,-1);
    
    underHangX=[];
    underHangY=[];
    underHangZ=[];
    
    overHangX=[];
    overHangY=[];
    overHangZ=[];
    
    if underOpt
        if kRange(1)==1
            underHangX=[];
            underHangY=[];
            underHangZ=[];
        else
            underHangX=dx(1:(min(kRange)-1));
            underHangY=dy(1:(min(kRange)-1));
            underHangZ=dz(1:(min(kRange)-1));
        end
    end
    
    if overOpt
        overHangX=dx((max(kRange)+1):N);
        overHangY=dy((max(kRange)+1):N);
        overHangZ=dz((max(kRange)+1):N);
    end
    
    normD1=sum(upperWeights)+length(underHangX);
    normD2=sum(lowerWeights)+length(overHangX);
    
    %Calculate means
    upperMeanDX=sum(upperDX)./normD1;
    upperMeanDY=sum(upperDY)./normD1;
    upperMeanDZ=sum(upperDZ)./normD1;
    
    lowerMeanDX=sum(lowerDX)./normD2;
    lowerMeanDY=sum(lowerDY)./normD2;
    lowerMeanDZ=sum(lowerDZ)./normD2;
    
    underHangMeanDX=sum(underHangX)./normD1;
    underHangMeanDY=sum(underHangY)./normD1;
    underHangMeanDZ=sum(underHangZ)./normD1;
    
    overHangMeanDX=sum(overHangX)./normD2;
    overHangMeanDY=sum(overHangY)./normD2;
    overHangMeanDZ=sum(overHangZ)./normD2;
    
    underD1=0;
    overD2=0;
    
    %Calculate critical region variance
    criticalD1=sum((upperDX-upperWeights.*repmat(upperMeanDX+underHangMeanDX,stepSize,1)).^2)./(normD1-1)+...
        sum((upperDY-upperWeights.*repmat(upperMeanDY+underHangMeanDY,stepSize,1)).^2)./(normD1-1)+...
        sum((upperDZ-upperWeights.*repmat(upperMeanDZ+underHangMeanDZ,stepSize,1)).^2)./(normD1-1);
    criticalD2=sum((lowerDX-lowerWeights.*repmat(lowerMeanDX+overHangMeanDX,stepSize,1)).^2)./(normD2-1)+...
        sum((lowerDY-lowerWeights.*repmat(lowerMeanDY+overHangMeanDY,stepSize,1)).^2)./(normD2-1)+...
        sum((lowerDZ-lowerWeights.*repmat(lowerMeanDY+overHangMeanDZ,stepSize,1)).^2)./(normD2-1);
    criticalD1(:,normD1==1)=0;
    criticalD2(:,normD2==1)=0;
    
    % tic
    % %Calculate overhang region variance
    % overD2=sum((repmat(overHangX,1,1000)-repmat(overHangMeanDX+lowerMeanDX,N-1000,1)).^2)./(normD2-1)...
    %     +sum((repmat(overHangY,1,1000)-repmat(overHangMeanDY+lowerMeanDY,N-1000,1)).^2)./(normD2-1)...
    %     +sum((repmat(overHangZ,1,1000)-repmat(overHangMeanDZ+lowerMeanDZ,N-1000,1)).^2)./(normD2-1);
    % overD2(:,normD2==1)=0;
    % toc
    
    
    
    if overOpt||underOpt
        for i=1:stepSize
            if overOpt;
                %Overhang diffusion
                overD2(i)=sum((overHangX-(overHangMeanDX(i)-lowerMeanDX(i))).^2)./(normD2(i)-1)+...
                    sum((overHangY-(overHangMeanDY(i)-lowerMeanDY(i))).^2)./(normD2(i)-1)+...
                    sum((overHangZ-(overHangMeanDZ(i)-lowerMeanDZ(i))).^2)./(normD2(i)-1);
            end
            if underOpt
                if min(kRange)>1
                    %underhang diffusion
                    underD1(i)=sum((underHangX-(underHangMeanDX(i)-upperMeanDX(i))).^2)./(normD1(i)-1)+...
                        sum((underHangY-(underHangMeanDY(i)-upperMeanDY(i))).^2)./(normD1(i)-1)+...
                        sum((underHangZ-(underHangMeanDZ(i)-upperMeanDZ(i))).^2)./(normD1(i)-1);
                end
            end
        end
    end
%     figure(hF);
    llrt=abs(sqrt(N.*log(Do)-normD1.*log(criticalD1+underD1)-normD2.*log(criticalD2+overD2)));
    llrt(isnan(llrt))=0;
    llrt(isinf(llrt))=0;
%     plot(kRange,llrt)
%     title([num2str(N) ' Total Points']);
    [llrtLocalMax kLocalMax]=max(llrt);
    if llrtLocalMax>=llrt_max
        llrt_max=llrtLocalMax;
        k_max=kRange(kLocalMax);
    end
%     axis square;
%     drawnow;
end
% close(hF)