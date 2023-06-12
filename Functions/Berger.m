function R=Berger(peaks_detection)
%% Load and Filter Data

% ----- Filter the detection around the average distances -----%
dif = 0.1;                              % Normal to Normal intervals precentage
win = 20;                               % Window size
diff_peaks = diff(peaks_detection);     % Diffrences between peaks

% First window
diff_peaks_window=diff_peaks(1:win-1);
diff_peaks_window(find(diff_peaks_window<((1-dif)*mean(diff_peaks_window)) | diff_peaks_window>((1+dif)*mean(diff_peaks_window))))=mean(diff_peaks_window);
diff_peaks_filtered(1:win-1)=diff_peaks_window;

% Rest of the windows
for i=1:floor(length(diff_peaks)/win)
    if length(diff_peaks)-i*win<win % Find the last window
        diff_peaks_window=diff_peaks(win*i:end);
        diff_peaks_window(find(diff_peaks_window<((1-dif)*mean(diff_peaks_window)) | diff_peaks_window>((1+dif)*mean(diff_peaks_window))))=mean(diff_peaks_window);
        diff_peaks_filtered(win*i:length(diff_peaks))=diff_peaks_window;
        
    else
        diff_peaks_window=diff_peaks(win*i:win*(i+1));
        diff_peaks_window(find(diff_peaks_window<((1-dif)*mean(diff_peaks_window)) | diff_peaks_window>((1+dif)*mean(diff_peaks_window))))=mean(diff_peaks_window);
        diff_peaks_filtered(win*i:win*(i+1))=diff_peaks_window;
    end
end
%figure; subplot(2,1,1); plot(diff_peaks_filtered); subplot(2,1,2);plot(diff_peaks);

%% Berger algorithm
Fr = 4;         % [Hz]
Fs = 1000;      % [Hz]
N = [];
R = [];

peaks=1;
for i=2:length(diff_peaks_filtered)
    peaks(end+1)=peaks(end)+diff_peaks_filtered(i);
end

Fr_vec = 2:250:peaks(end); % Resampling vector
find_peak_vec = []; % Find all the peaks


for i=1:length(Fr_vec)-2
   
    find_peak = find(peaks>=Fr_vec(i) & peaks<=Fr_vec(i+2)); % Finds if there is a peak within a window 
   
   if isempty(find_peak)==1
       if isempty(find_peak_vec)==1 % Extreme case - in case there was no detection prior this point
           
           I = (peaks(2)-peaks(1))/Fs; % If there is no detection in the beggining of the signal I determined between the closest peaks
           N(i) = (2/Fr)/I;
           R(i) = N(i)*(Fr/2);
           
       else % Find I based on the last peak detection inside the window
           
           I = (peaks(find_peak_vec(end)+1)-peaks(find_peak_vec(end)))/Fs;
           N(i) = (2/Fr)/I;
           R(i) = N(i)*(Fr/2);
           
       end
       
   else % Deals with peak detection inside the window
        
        find_peak_vec=[find_peak_vec find_peak]; % adds the last detection to the vector for counting
        
        I_before = (peaks(find_peak)-peaks(find_peak-1))/Fs;
        I_after = (peaks(find_peak+1)-peaks(find_peak))/Fs;
        b = (peaks(find_peak)-Fr_vec(i))/Fs;
        c = (Fr_vec(i+2)-peaks(find_peak))/Fs;
        
        N(i) = ((b/I_before)+(c/I_after));
        R(i) = N(i)*(Fr/2);
           
   end
   
end