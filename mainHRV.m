clc ; clear all; close all;
mainpath = pwd;

addpath(strcat(mainpath,'\Functions'))

%% Load and Filter Data
load(strcat(mainpath,'\Data\Peaks.mat'));
Fr = 4;         % [Hz]
Fs = 1000;      % [Hz]

for i=1:10
    peaks_detection=Peaks{i,1}.PeakDetection.Rwaves;
    R(i)={Berger(peaks_detection)};
end
%% HRV & PSD calculations

%---------------------%
% Heart rate vs. Time
figure; hold on;
for i=1:3
    RR=cell2mat(R(i+7));
    HRV = (60.*RR);
    t = (0:250:250*length(HRV)-1)./1000;
    plot(t,HRV) 
end
xlabel('time [sec]'); ylabel('Heart rate [Beats/Minute]');
legend('Subject 8','Subject 9','Subject 10')
title('Heart rate over time: Full Signal'); grid on; 

% PSD vs. frequencies [Hz]
figure;
for i=1:3
    RR=cell2mat(R(i+7));
    HRV = (60.*RR);
    [pxx,f] = pwelch(HRV,[],[],[],Fr);
    subplot(3,1,i); plot(f,pow2db(pxx));
    xlabel('Frequency (Hz)'); ylabel('PSD (dB/Hz)');
    title(append('HRV PSD: Subject ',num2str(i+7))); grid on;  
end

%---------------------%

for i=1:10
    % Load data
    RR=cell2mat(R(i));  % RR vector for each subject
    HRV = (60.*RR); 
    min_dif = 0.2;      % Rest phase deviation
    max_dif = 0.4;      % Exertion phase deviation
    t = (0:250:250*length(HRV)-1)./1000;
    amp_diff= max(HRV)-min(HRV);
    
    % HRV rest 
    Rest_loc = find(HRV>=min(HRV) & HRV<=(amp_diff*min_dif)+min(HRV));
    t_rest = t(Rest_loc);
    HRV_rest = HRV(Rest_loc);
    
    % PSD vs. frequencies [Hz]
    [pxx_rest,f_rest] = pwelch(HRV_rest,[],[],[],Fr);
    LF_rest(i)=sum(pow2db(pxx_rest(find(f_rest>=0.04 & f_rest<=0.15))));
    HF_rest(i)=sum(pow2db(pxx_rest(find(f_rest>=0.15 & f_rest<=0.4))));

    % HRV Exertion
    Exertion_loc=find(HRV>=max(HRV)-(amp_diff*max_dif) & HRV<=max(HRV));
    t_Exertion=t(Exertion_loc);
    HRV_Exertion=HRV(Exertion_loc);

    % PSD vs. frequencies [Hz]
    [pxx_exertion,f_exertion] = pwelch(HRV_Exertion,[],[],[],Fr);
    LF_exertion(i)=sum(pow2db(pxx_exertion(find(f_exertion>=0.04 & f_exertion<=0.15))));
    HF_exertion(i)=sum(pow2db(pxx_exertion(find(f_exertion>=0.15 & f_exertion<=0.4))));
end

Ratio_rest=mean(LF_rest(2:end)./HF_rest(2:end));
Ratio_exertion=mean(LF_exertion(2:end)./HF_exertion(2:end));
std_rest=std(LF_rest(2:end)./HF_rest(2:end));
std_exertion=std(LF_exertion(2:end)./HF_exertion(2:end));

state = categorical({'Rest','Exertion'});
state = reordercats(state,{'Rest','Exertion'});
figure; bar(state,[Ratio_rest Ratio_exertion]); hold on;
errorbar([Ratio_rest Ratio_exertion],[std_rest std_exertion],'.')
title('LF/HF Ratio: Rest vs. Exertion')
