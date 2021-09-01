function  [] = GOdist_create_hist_2_for_gradient_graph(expname,data_dir,ontology,GOterm,log_value);

[params paramnames]=create_parameters(data_dir,expname);
%we do not use GENE_ID here, but other functions that call
%get_all_genes_with_term, do
[GENE_ID rel_ung log_ratios ]= GOdist_get_all_genes_with_term(expname,data_dir,params,paramnames,GOterm,ontology);

log_base = 2;
if (log_value==10) 
    log_base = 10;
    log_ratios = log_ratios/log2(10);
end

%delta =8; 
x = -4.0:0.1:4.0;
size = length(log_ratios);

%[Na,Xa]=hist(log_ratios,delta);
[Na,Xa]=hist(log_ratios,x);
size = length(log_ratios);
one_per = size/100;

save ('D:\usr\lilach\work\Yoram\input\affymetrix_Math1#2\GodistInput\withoutcontrols\Na','Na','Xa');  
disp('saved Na');
%Na=Na/delta;
%y_name = 'N';

% plot correct classifications as a function of STD and mean of the data
% distribution
CSTD = [-4:1:4];
%CM     = [0:0.1:1];
%aD1 = 100*Na./N_ITE; % Convert to percentages
%aD2 = 100*aD2./N_ITE;
figure
%subplot(1,3,1)
imagesc(Na,[0 100]);
%set(gca,'xlim',[1 9])
%set(gca,'ylim',[1 11])
set(gca,'xtick',1:9);
%set(gca,'ytick',1:11);
set(gca,'xticklabel', num2str(CSTD'))
%set(gca,'yticklabel', num2str(CM'))
%yh = ylabel('mean'); set(yh,'fontsize',14);
xh = xlabel('exp. log ratio'); set(xh,'fontsize',14);
set(gca,'xtick',[1:8])
%set(gca,'xticklabel',{'-4','-3','-2','-1','0','1','2','3','4'})
%set(gca,'ytick',[1.0 3.0  5.0  7.0  9.0  11.0 ]);
%set(gca,'yticklabel',{'0','0.2','0.4','0.6','0.8','1.0'})
set(gca,'fontsize',14)
%set(gca,'ylim',[0.5 11.5])
%set(gca,'xlim',[-4.5 4.5])
th = title('gradient of expression '); set(th,'fontsize',14)
ch = colorbar
set(ch,'yticklabel',{'0','','20' ,'' ,'40' ,'' ,'60' ,'' ,'80' ,'' ,'100'})
set(ch,'fontsize',14)
axis square
%colormap(flipud(hot))
set(gcf,'color','none')