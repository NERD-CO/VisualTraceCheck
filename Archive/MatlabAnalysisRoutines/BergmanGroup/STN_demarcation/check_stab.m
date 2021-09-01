function [Data1,Data2,skip_trace]=check_stab(Data1,Data2,Info)
step_ms=50;
skip_trace=[0 0];
step(1)=round(Info(1).SampleRate*step_ms/1000); step(2)=round(Info(2).SampleRate*step_ms/1000);
Data{1}=Data1; Data{2}=Data2;

for i=1:2
    clear Elec_data RMS_seq outlier_idxs
    counter=0;
    Elec_Data=Data{i};
    if all(isnan(Elec_Data)), break, end %if the data is NaN, exit the for and return NaN
    while (counter+1)*step(i) < length(Elec_Data)
        RMS(i,counter+1)=rms(Elec_Data((counter*step(i)+1):((counter+1)*step(i))));
        counter=counter+1;
    end
    med_RMS(i)=median(RMS(i,RMS(i,:)~=0)); %median about the non-zero RMS values (incase part of the signal is zeros)
    std_RMS(i)=std(RMS(i,:)); 
    RMS_seq=(RMS(i,:)< med_RMS(i)+3*std_RMS(i)) & (RMS(i,:) > max(0,med_RMS(i)-3*std_RMS(i))); %find RMS within bounds
    outlier_idxs=find(not(RMS_seq)); 
    outlier_idxs=[0 outlier_idxs length(RMS_seq)+1]; %add an outlier index to beginnig and end to allow sequences from beg/till end
    [max_diff,idx]=max(diff(outlier_idxs)); %use outliers indexes to define longest stable section
    seq_len=max_diff-1;
    data_range(i,:)=outlier_idxs(idx)*step(i)+[1 seq_len*step(i)];
    eval(sprintf('Data%u=Data%u([data_range(%u,1):data_range(%u,2)]);',i,i,i,i));
    if data_range(i,2)-data_range(i,1)<Info(i).SampleRate, skip_trace(i)=1; end %longest stable section is shorter than 1s
%     figure; 
%     subplot(2,1,1), plot(Elec_Data)
%     subplot(2,1,2), plot(RMS(i,:),'b'); hold on;
%     plot(med_RMS(i)*ones(1,length(RMS(i,:))),'k')
%     plot((med_RMS(i)+3*std_RMS(i))*ones(1,length(RMS(i,:))),'r')
end

function [rms] = rms(x)
rms = norm(x)/sqrt(length(x));
