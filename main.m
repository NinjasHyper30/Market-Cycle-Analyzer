%%Preprocess
clc;
clear all;
load('Nifty.mat');
Date=NIFTY50.Date;
P=NIFTY50.CLOSE;
P=flip(P); Date=flip(Date);
%% Computation
ALTH=P(1); prevH=P(1); prevL=P(1); bullGain=0; bullDate=Date(1); bearLoss=0; bearDate=Date(1); bl=true; 
 blsd=Date(1); brsd=Date(1); bled=Date(1); bred=blsd;
 bullDur=between(blsd,bled,'weeks'); bearDur=between(blsd,bled,'weeks');
for i=2:size(P)
 if(P(i)>=ALTH)
     ALTH=P(i);
     bl=1;
 end
 if(bl)
     if(P(i)>prevH)
         prevH=P(i);
         bled=Date(i);
         continue;
     end
     pr=((prevH-P(i))/prevH)*100;
     if(pr>20)
         gain=((prevH-prevL)/prevL)*100;
         bullGain(end+1)=gain; bearDate(end+1)=Date(i);
         bl=false;  prevL=P(i);
         x=between(blsd,bled,'weeks');
         bullDur(end+1)=x;
         brsd=Date(i); bred=brsd;
     end
 else
     if(P(i)<prevL)
         prevL=P(i);
         bred=Date(i);
         continue;
     end
     pr=((P(i)-prevL)/prevL)*100;
     if(pr>20)
         loss=((prevH-prevL)/prevH)*100;
         bearLoss(end+1)=loss; bullDate(end+1)=Date(i);
         bl=true;  prevH=P(i);
         x=between(brsd,bred,'weeks');
         bearDur(end+1)=x;
         blsd=Date(i); bled=blsd;
     end
 end
end 
if(bl)
    gain=((prevH-prevL)/prevL)*100;
    bullGain(end+1)=gain;
    x=between(blsd,bled,'weeks');
    bullDur(end+1)=x;
else
    loss=((prevH-prevL)/prevH)*100;
    bearLoss(end+1)=loss; 
    x=between(brsd,bred,'weeks');
    bearDur(end+1)=x;
end

bullGain=bullGain(2:end);
bearLoss=bearLoss(2:end);
bearDate=bearDate(2:end);
bullDur=bullDur(2:end);
bearDur=bearDur(2:end);
%% data analysis
figure(1);
plot(Date,P);
grid on;
xlabel('DATE'); ylabel('Points');
title(' NIFTY50 index');
figure(2);
bar(bearDate,bearLoss);
title('BEAR LOSS');
figure(3);
bar(bullDate,bullGain);
title('BULL GAIN');

averageBullGain=mean(bullGain);
averageBearLoss=mean(bearLoss);
disp("Average bull Gain"); disp(averageBullGain);
disp("Average bear Loss"); disp(averageBearLoss);
