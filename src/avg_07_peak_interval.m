function A = avg_07_peak_interval(~, signal)  %Comentar mais tarde
threshold = max(signal)*0.07;
[~,locs] = findpeaks([0; signal; 0], 'MinPeakHeight', threshold);
A = mean(abs(diff(locs)));
if isnan(A), A = 0; end
end


