%%% the script to generate the main figures (Figs.1-4) in "Mapping the global distribution of C4 vegetation using observations and optimality theory"
%%% Date: Jan 15, 2024, by Xiangzhong (Remi) Luo, at Dept. of Geography, NUS.

clear all;
warning off;

% directory to save code and data (users need to edit the directories).
code_data_dir = '/Users/xiangzhongluo/Library/CloudStorage/Dropbox/Code/project20_c3c4/sup_code_data';
output_dir = '/Users/xiangzhongluo/Dropbox/Figures';

% load the organized data for figure productions.
load([code_data_dir,'/master_data_c4.mat']);

%%%% include the following variables:
%'opt_AC4_AC3_ratio': estimated annual AC4/AC3 from the optimality model, for 2001 - 2019.
%'opt_AC4_AC3_ratio_refs': estimated annual AC4/AC3 from the optimality model, reference cases where CO2, Tair, VPD, SM are controlled.
%'grassy_per': the mean global grass fraction from mutiple remote sensing products.
%'grassy_per_un': the uncertainty of global grass fraction.
%'DG_AC43_data': the observations from Griffith et al. 2017 J. of Biogeography, and the corresponding AC4/AC3
%'TRY_AC43_data': the observations from the TRY database, and the corresponding AC4/AC3
%'MAT': mean annual air temperature 2001-2019
%'MAP': mean annual precipitation 2001-2019
%'c4_grass_area': estimated C4 natural grass area (based on opt_AC4_AC3_ratio, observations and grassy_per)
%'c4_grass_area_un': the uncertainty of estimated C4 natural grass area
%'c4_crop_area': estimated C4 crop area, from LUH dataset
%'c4_crop_area_un': uncertainty of estimated C4 crop area, assumed to be 10% of c4_crop_area
%'c4_area': estimated total C4 area
%'C4_type_crop_ratio': the percentage of three types of C4 crops, estimated based on Jackson et al. 2019 ERL.
%'constraint_slope': the changes in the emergent constraint slopes between C4 area and C4 GPP
%'constraint_slope_un': the uncertainty of the emergent constraint slopes between C4 area and C4 GPP
%'dgvm_c4_grass_1D': the percentage of C4 grass over vegetated surface estimated from 11 DGVMs
%'dgvm_c4_grass_gpp_1D': the percentage of C4 grass GPP over global GPP from 11 DGVMs
%'dgvm_c4_crop_1D': the percentage of C4 crop over global vegetated surfce from 7 DGVMs
%'dgvm_c4_crop_gpp_1D': the percentage of C4 crop GPP over global GPP from 7 DGVMs
%'trendy_c4': the spatial distribution of C4 grass, C4 crop and total C4 for all 11 DGVMs from 1992 to 2019.


%%%%%%%%%%%%%% Start: Figure 1, optimality model, observational constraint and C4 grass coverage %%%%%%%%
f1=figure('Name','histo of estimates','Units', 'centimeters','Color','white', 'Position', [2, 2, 18, 15], ...
    'OuterPosition', [2, 2, 18, 15]);

% panel gaps figuration
SpacingVert = 0.00;
SpacingHoriz = 0.07;
MR = 0.03;
ML = 0.01;
MarginTop = 0.01;
MarginBottom = 0.01;

%%%% Panel (a), estimated AC4/AC3
zdata = squeeze(nanmean(opt_AC4_AC3_ratio,3)); % the mean of 2001-2019

lat=-89.75:0.5:89.75;
lon=-179.75:0.5:179.75;

cd(code_data_dir);
subaxis(2,2,1,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom); 

mapdata=flip(zdata);

cd([code_data_dir, '/m_map']);
m_proj('Miller','lon',[-180 180],'lat',[-60 90]); % map projections, range of lon and lat of your data, Robinson
m_coast('linewidth',0.5,'color',[0.2 0.2 0.2]); % coast line settings
hold on;
m_pcolor(lon,lat,mapdata); % draw your map here
shading INTERP;   % can be flat or INTERP

colorscheme =  [242,240,247;...
240,249,232;...
217,240,211;...
166,219,160;...
90,174,97;...
27,120,55]./255;

colormap(gca,colorscheme);

caxis([0 3]); 
    
h=colorbar;%
set(h,'YTick',0:0.5:3);
ylabel(h,{'AC_4/AC_3'},'FontSize',9);
cd(code_data_dir);cbfreeze(h);

cd([code_data_dir, '/m_map']);
m_grid('box','off','tickdir','in','yticklabels',[],'xticklabels',[],'fontsize',7);

text(-2.9,2.6,strcat('(',char(96+1),')'),'fontsize',10);


%%%% Panel (c), estimated C4 coverage: C4 natural grassland per grasslands
coef_a = -4.041;
coef_b = 5.988;
opt_C4_coverage = 1/(exp(coef_a*opt_AC4_AC3_ratio+coef_b)+1);

% in case remove outliers.
opt_C4_coverage(opt_C4_coverage>1) = 1;
opt_C4_coverage(opt_C4_coverage<0) = 0;

zdata = squeeze(nanmean(opt_C4_coverage,3).*100); % the mean of 2001-2019

cd(code_data_dir);
subaxis(2,2,3,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom); 
mapdata=flip(zdata);

cd([code_data_dir, '/m_map']);
m_proj('Miller','lon',[-180 180],'lat',[-60 90]); % map projections, range of lon and lat of your data, Robinson
m_coast('linewidth',0.5,'color',[0.2 0.2 0.2]); % coast line settings
hold on;
m_pcolor(lon,lat,mapdata); % draw your map here
shading INTERP;   % can be flat or INTERP

colorscheme =  [188,189,220;...
 218,218,235;...
 242,240,247;...
    240,249,232;...
    217,240,211;...
    180,219,160;...
    130,195,120;...
    90,174,97;...
    35,139,69;...
    10,88,36]./255;

colormap(gca,colorscheme);

caxis([0 100]); 
    
h=colorbar;%
set(h,'YTick',0:10:100);
ylabel(h,{'C_4 grass coverage'; '(% of grassland)'},'FontSize',9);
cd(code_data_dir);cbfreeze(h);

cd([code_data_dir, '/m_map']);
m_grid('box','off','tickdir','in','yticklabels',[],'xticklabels',[],'fontsize',7);

text(-2.9,2.6,strcat('(',char(96+3),')'),'fontsize',10);


%%%% Panel (b), the link between estimated AC4/AC3 and obs. of DG and TRY.

cd(code_data_dir);
subaxis(2,2,2,'SpacingVert',SpacingVert+0.15,'SpacingHoriz',SpacingHoriz+0.17,'MR',MR,'ML',ML,'MarginTop',MarginTop + 0.05,'MarginBottom',MarginBottom +0.1); 

    %%% load the DG dataset. DG dataset report C4 coverage: percentage of grassland covered by C4, at 1 degree. Excel table from SI of Griffith 2015 J. of Biogeography.
    ydata_1 = DG_AC43_data(:,1);
    xdata_1 = DG_AC43_data(:,2);

    %%% load the TRY dataset. We got species richness from TRY: percentage of C4 grass species in total species number
    ydata_2 = TRY_AC43_data(:,1).*1.51;
    xdata_2 = TRY_AC43_data(:,3);

    % merge DG and TRY datasets.
    xdata = [xdata_1;xdata_2];
    ydata = [ydata_1;ydata_2];
    

    % The scatter plot of estimated AC4/AC3 and obs. C4 coverage
    hold on;
    s2 = scatter(xdata_2,ydata_2,8,'MarkerEdgeColor',[239,138,98]./255,... %% TRY
              'MarkerFaceColor',[239,138,98]./255,...
              'LineWidth',0.5);
    s1 = scatter(xdata_1,ydata_1,8,'MarkerEdgeColor',[103,169,207]./255,... %% DG
              'MarkerFaceColor',[103,169,207]./255,...
              'LineWidth',0.5);
    h=gca;
    h.YTickLabel = {'0','50','100'};
    ylim([-0.1,1.3]);
    xlim([0.6,2.6]);
    
    xlabel('Estimated AC_4/AC_3','Fontsize',9);
    ylabel({'C_4 grass coverage'; '(% of grassland)'},'Fontsize',9);


    hold on;

    % add the fitted curve
    cd(code_data_dir);
    [fitresult, gof] = createFit_logistic(xdata, ydata);
    xint = linspace(0,3,100);
    [CIF, yint] = predint(fitresult,xint,0.95,'Functional');
    pxx= plot(xint, yint,'--','color','k');

    hold on;

    % show the statistics
    xmin = nanmin(xdata);
    xmax = nanmax(xdata);
    ymin = nanmin(ydata);
    ymax = nanmax(ydata);

    text(0.85,1.20,strcat('r=',num2str(0.73),{' '},'(p<0.001) '),'Color','k','FontSize',10); % statisical text suggest p < 0.01.
    text(0.85,1.06,strcat('y = 1/(exp(', num2str(round(fitresult.a,2)), 'x+', num2str(round(fitresult.b,2)),')+1)'),'Color','k','FontSize',10);

    % show the uncertainty range
    ydata_low=CIF(:,1);
    ydata_up=CIF(:,2);
    hold on;

    xdata_rev = xint';
    [xdata2_s2,I] = sort(xdata_rev);

    h=fill([xdata2_s2; flip(xdata2_s2)], [ydata_low(I); flip(ydata_up(I))], 'k');
    set(h,'facealpha',.2);
    set(h,'LineStyle','none');
    
    hold on;

    % fitted line for TRY dataset
    cd(code_data_dir);
    [fitresult2, gof2] = createFit_logistic(xdata_2, ydata_2);
    [~, yint2] = predint(fitresult2,xint,0.95,'Functional');
    pxx= plot(xint, yint2,'--','color',[239,138,98]./255);

    % fitted line for DG dataset
    cd(code_data_dir);
    [fitresult1, gof1] = createFit_logistic(xdata_1, ydata_1);
    [~, yint1] = predint(fitresult1,xint,0.95,'Functional');
    pxx= plot(xint, yint1,'--','color', [103,169,207]./255);

    % panel number
    hold on;
    text(0.65,1.15,strcat('(',char(96+2),')'),'fontsize',10);

    legend([s2 s1],'TRY','DG','Location','southeast');


%%%% Panel (d), the distribution in the climatic zones %%%%%%
cd(code_data_dir);
subaxis(2,2,4,'SpacingVert',SpacingVert+0.1,'SpacingHoriz',SpacingHoriz+0.2,'MR',MR,'ML',ML,'MarginTop',MarginTop +0.1,'MarginBottom',MarginBottom+0.1); 

% generate a 100*100 matrix based on MAT (0-40 C) and MAP (0-4000 mm/yr)

x1D = reshape(MAT,[],1);
y1D = reshape(MAP,[],1);
z1D = reshape(nanmean(opt_C4_coverage.*100,3),[],1);
z1D(x1D < 0 & y1D > 4000) = NaN;

% display the data in a heat map.
heat_map_C4 = nan(100,100);

for ii = 1:100 % assign values to the heat density map
    
    pp_min = 0+(ii-1).*40; pp_max = 0+ii.*40;

    for jj = 1:100

        tt_min = 0+(jj-1).*0.4; tt_max = 0+jj.*0.4;

        z_ind = x1D > tt_min & x1D < tt_max & y1D > pp_min & y1D < pp_max;

        if sum(z_ind) > 0
            heat_map_C4(101-ii,jj) = nanmean(z1D(z_ind));
        else
            heat_map_C4(101-ii,jj) = NaN;
        end

    end

end

heat_map_C4 = flip(heat_map_C4);
heat_map_C4_cut = heat_map_C4(:,1:80); % 0 - 32 Celsius degree for MAT.

h=pcolor(heat_map_C4_cut);%if interval too large, then the color cannot show
set(h, 'EdgeColor', 'none');

colorscheme =  [188,189,220;...
     218,218,235;...
     242,240,247;...
        240,249,232;...
        217,240,211;...
        180,219,160;...
        130,195,120;...
        90,174,97;...
        35,139,69;...
        10,88,36]./255;

colormap(gca,colorscheme); %or flip(gray(50)) jet(50)

set(gca,'XTick',0:12.5:80); % scale for MAT
set(gca,'xticklabels',{'0','5','10','15','20','25','30','35','40'});
set(gca,'YTick',0:12.5:100); % scale for MAP
set(gca,'yticklabels',{'0','500','1000','1500','2000','2500','3000','3500','4000'});


xlabel(['MAT (' char(176) 'C)'],'Fontsize',9); % labels.
ylabel('MAP (mm/yr)','Fontsize',9);

xline(55,'--r',['22' char(176) 'C']);
caxis([0 100]); 
    
h=colorbar;%
set(h,'YTick',0:10:100);
ylabel(h,{'C_4 coverage (% of grassland)'},'FontSize',9);

text(0,110,strcat('(',char(96+4),')'),'fontsize',10);


set(f1,'PaperPositionMode','auto');
print([output_dir, '/c4_Figure_1'],'-djpeg','-r600');
saveas(gcf,[output_dir, '/c4_Figure_1.pdf']);


%%%%%%%%%% END: Figure 1, optimality model, observational constraint and C4 grass coverage  %%%%%%%%%%%%%%%%%









%%%%%%% Start: Figure 2. C4 distribution and the uncertainties %%%%%%%%

% quantify the uncertainty of C4 grass coverage
un_range = ydata_up - ydata_low; % define uncertainty as the CIs, obtained from Fig. 1.
opt_C4_coverage_un = nan(size(opt_C4_coverage));

for cfrac = 0:5:95
    
    %tmp_ind = ypred > 0 & ypred < 5; % just use the average shaded area
    tmp_ind = yint*100 > cfrac & yint*100 < cfrac+5;
    opt_C4_coverage_un (opt_C4_coverage > cfrac & opt_C4_coverage < cfrac+5) = nanmean(un_range(tmp_ind)); % apply the uncertainty range to the space
end

opt_C4_coverage_un(opt_C4_coverage > 95) =  nanmean(un_range(tmp_ind)./2); % if C4% is more than 60, use the 55-60 percentage uncertainty.

opt_C4_coverage_un = 100.*opt_C4_coverage_un; % convert to 0-100

% the true uncertainty for C4 area is based on the unc of grassland and the unc of the observational constraint
% https://www.johndcook.com/blog/2012/10/29/product-of-normal-pdfs

% C4 natural grass uncertainty 1: due to land cover dataset is available in c4_grass_area_un;
% C4 natural grass uncertainty 2: due to observational constraint, calculated above;

c4_grass_area_un_final = sqrt((c4_grass_area_un.^2.*opt_C4_coverage_un.^2)./(c4_grass_area_un.^2 + opt_C4_coverage_un.^2));

% merge the uncertainty of C4 grass and C4 crop together
c4_area_un = sqrt(c4_grass_area_un_final.^2 + c4_crop_area_un.^2);


%%%%%%%%% Start to plot
f2=figure('Name','histo of estimates','Units', 'centimeters','Color','white', 'Position', [2, 2, 18, 17.8], ...
    'OuterPosition', [2, 2, 18, 17.8]);

% panel gaps figuration
SpacingVert = 0.00;
SpacingHoriz = 0.07;
MR = 0.03;
ML = 0.01;
MarginTop = 0.01;
MarginBottom = 0.01;

% Panel (a) - (f)
for i = 1:6

    switch i
        case 5
            zdata = nanmean(c4_area,3);
            class = 'C_4';
        case 1
            zdata = nanmean(c4_grass_area,3);
            class = 'C_4 natural grasses';
        case 3
            zdata = nanmean(c4_crop_area,3);
            class = 'C_4 crops';
        case 6
            zdata = nanmean(c4_area_un,3);
            class = 'C_4 uncertainty';
        case 2
            zdata = nanmean(c4_grass_area_un_final,3);
            class = 'C_4 natural grasses uncertainty';
        case 4
            zdata = nanmean(c4_crop_area_un,3);
            class = 'C_4 crops uncertainty';
    end

    cd(code_data_dir);
    subaxis(3,2,i,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom); 

    mapdata=flip(zdata);
    mapdata(mapdata == 0) = NaN;
    
    cd([code_data_dir,'/m_map']);
    m_proj('Miller','lon',[-180 180],'lat',[-60 90]); % map projections, range of lon and lat of your data, Robinson
    m_coast('linewidth',0.5,'color',[0.2 0.2 0.2]); % coast line settings
    hold on;
    m_pcolor(lon,lat,mapdata); % draw your map here
    shading INTERP;   % can be flat or INTERP

if mod(i,2) == 0 % use a different color scheme to show uncertainty
    colorscheme =  [222,235,247;...
         247,251,255;...
         255,245,235;...
        254,230,206;...
        253,208,162;...
        253,174,107;...
        253,141,60;...
        241,105,19;...
        217,72,1;...
        140,45,4]./255;

    colormap(gca,colorscheme);

else
        colorscheme =  [188,189,220;...
         218,218,235;...
         242,240,247;...
        240,249,232;...
        217,240,211;...
        180,219,160;...
        130,195,120;...
        90,174,97;...
        35,139,69;...
        10,88,36]./255;

        colormap(gca,colorscheme);
end

    % scale for uncertainty and distribution maps.
    if mod(i,2) == 0
        caxis([0 10]); 
        h=colorbar;%
        set(h,'YTick',0:1:10);
    else
        caxis([0 50]); 
        h=colorbar;%
        set(h,'YTick',0:5:50);
    end
    ylabel(h,{'% of land surface'},'FontSize',9);
    cd(code_data_dir);cbfreeze(h);
    
    cd([code_data_dir,'/m_map']);
    m_grid('box','off','tickdir','in','yticklabels',[],'xticklabels',[],'fontsize',7);

    text(-2.9,2.6,strcat('(',char(96+i),')',{' '},class),'fontsize',10);
           
end

set(f2,'PaperPositionMode','auto');
print([output_dir, '/c4_Figure_2'],'-djpeg','-r600');
saveas(gcf,[output_dir, '/c4_Figure_2.pdf']);
%%%%%% End: Figure 2. C4 distribution and the uncertainties %%%%%%%%%%%%%%%%%%%%%%






%%%%%%%% Start: Figure 3. Changes in C4 distribution from 2001 to 2019 %%%%%%%%%%%%%%%

%%% getting some supporting data, the surface area
% the total vegetated land surface
cd(code_data_dir);
h_area = get_native_area(-89.75:0.5:89.75,-179.75:0.5:179.75);
total_land = 117.*10^12; %m2


f3=figure('Name','C4 area change','Units', 'centimeters','Color','white', 'Position', [2, 2, 18, 17.8], ...
    'OuterPosition', [2, 2, 18, 17.8]);

% panel configurations
SpacingVert = 0.00;
SpacingHoriz = 0.07;
MR = 0.03;
ML = 0.01;
MarginTop = 0.01;
MarginBottom = 0.01;

% Panels (a),(c),(d): the changes in total C4, C4 grass and C4 crop.
for i = 1:3

    switch i
        case 1
            zdata = nanmean(c4_area(:,:,end-4:end),3) - nanmean(c4_area(:,:,1:5),3); % use the difference between the first 5 and the last 5 years
            class = 'C_4';
        case 2
            zdata = nanmean(c4_grass_area(:,:,end-4:end),3) - nanmean(c4_grass_area(:,:,1:5),3);
            class = 'C_4 natural grasses';
        case 3
            zdata = nanmean(c4_crop_area(:,:,end-4:end),3) - nanmean(c4_crop_area(:,:,1:5),3);
            class = 'C_4 crops';
    end

   cd(code_data_dir);
   subaxis(3,2,2*(i-1)+1,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom); 

    mapdata=flip(zdata);
    
    cd([code_data_dir,'/m_map']);
    m_proj('Miller','lon',[-180 180],'lat',[-60 90]); % map projections, range of lon and lat of your data, Robinson
    m_coast('linewidth',0.5,'color',[0.2 0.2 0.2]); % coast line settings
    hold on;
    m_pcolor(lon,lat,mapdata); % draw your map here
    shading INTERP;   % can be flat or INTERP

    colorscheme =  [165,15,21;...       
    251,106,74;...
    252,187,161;...
    116,169,207;...
    43,140,190;...
    4,90,141]./255;     
    
    colormap(gca,colorscheme);
    
    caxis([-9 9]); 
        
    h=colorbar;%
    set(h,'YTick',-9:3:9);
    ylabel(h,{'Area abundance change (%)'},'FontSize',9);
    cd(code_data_dir);cbfreeze(h);
    
    cd([code_data_dir,'/m_map']);
    m_grid('box','off','tickdir','in','yticklabels',[],'xticklabels',[],'fontsize',7);

    text(-2.9,2.6,strcat('(',char(96+2*i-1),')',{' '},class),'fontsize',10);
       

end


% Panel (b): The time series of C4 area.
cd(code_data_dir);
subaxis(3,2,2,'SpacingVert',SpacingVert+0.1,'SpacingHoriz',SpacingHoriz+0.1,'MR',MR,'ML',ML,'MarginTop',MarginTop+0.05,'MarginBottom',MarginBottom+0.1); 


% the matrix to store the area percentage and its associated uncertainty
area_record = nan(19,3);
area_record_un = nan(19,3);

h_area2 = rot90(h_area,1);

area_record(:,1) = squeeze(nansum(nansum(c4_area.*h_area2,1),2))./total_land;
area_record(:,2) = squeeze(nansum(nansum(c4_grass_area.*h_area2,1),2))./total_land;
area_record(:,3) = squeeze(nansum(nansum(c4_crop_area.*h_area2,1),2))./total_land;

area_record_un(:,1) = squeeze(nansum(nansum(c4_area_un.*h_area2,1),2))./total_land;
area_record_un(:,2) = squeeze(nansum(nansum(c4_grass_area_un_final.*h_area2,1),2))./total_land;
area_record_un(:,3) = squeeze(nansum(nansum(c4_crop_area_un.*h_area2,1),2))./total_land;

facecolor =  [127,201,127;...
            190,174,212;...
            253,192,134]./255;

year_range = [2001:2019]';

% plot the time series
for i = 1:3
    hold on;
    plot(year_range, area_record(:,i),'-','color',facecolor(i,:));
    
    h=fill([year_range; flip(year_range)], [area_record(:,i) - area_record_un(:,i); flip(area_record(:,i) + area_record_un(:,i))], facecolor(i,:));
    set(h,'facealpha',.2);
    set(h,'LineStyle','none');

end

ylim([0,20]);

text(2001,21.5,strcat('(',char(96+2),')'),'fontsize',10);
text(2001,4,'C_4 crops','fontsize',8,'Color', facecolor(3,:));
text(2001,13,'C_4 natural grasses','fontsize',8,'Color', facecolor(2,:));
text(2001,18,'Total C_4','fontsize',8,'Color', facecolor(1,:));     

xlabel('Year','Fontsize',10);
ylabel({'% of the land surface'},'Fontsize',10);


% Panel (d): The synergies between C4 grass and C4 crop changes
cd(code_data_dir);
subaxis(3,2,4,'SpacingVert',SpacingVert+0.15,'SpacingHoriz',SpacingHoriz+0.1,'MR',MR,'ML',ML+0.05,'MarginTop',MarginTop + 0.1,'MarginBottom',MarginBottom+0.1); 

tmp = nanmean(c4_grass_area(:,:,end-4:end),3) - nanmean(c4_grass_area(:,:,1:5),3);
xdata = reshape(tmp,[],1);

tmp = nanmean(c4_crop_area(:,:,end-4:end),3) - nanmean(c4_crop_area(:,:,1:5),3);
ydata = reshape(tmp,[],1);


% get the percentage of ++ -- +- -+ pixels
ind = isnan(xdata) | isnan(ydata);
consis(1) = sum(~ind);

ind = xdata > 0 & ydata > 0; consis(2)= sum(ind)./consis(1);
ind = xdata < 0 & ydata < 0; consis(3)= sum(ind)./consis(1);
ind = xdata > 0 & ydata < 0; consis(4)= sum(ind)./consis(1);
ind = xdata < 0 & ydata > 0; consis(5)= sum(ind)./consis(1);


b = bar(consis(2:5).*100,'FaceColor',[166 206 227]/255,'EdgeColor','none');
b(1).EdgeColor = 'flat';
b(1).LineWidth = 1.5;

hold on;

set(gca, 'box', 'off');

factor_names = {'++';'--';'+-';'-+'};

ylabel({'Synergies of C_4 grasses'; 'and crops changes (%)'},'FontSize',10);
ylim([0 50]);
h = gca;
h.XTick = 1:length(factor_names);
h.XTickLabel = factor_names;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';

text(-0.4,58,strcat('(',char(96+4),')'),'fontsize',10);



% Panel (f): The reasons for changes in C4 grass and C4 crop
cd(code_data_dir);
subaxis(3,2,6,'SpacingVert',SpacingVert+0.1,'SpacingHoriz',SpacingHoriz + 0.15,'MR',MR,'ML',ML,'MarginTop',MarginTop + 0.1,'MarginBottom',MarginBottom + 0.08); 
    
    %%%%%% prepare input for a few reference cases
    %%%%%% refer 1: average climate from 1981-2019
    %%%%%% refer 2: 2001 case with 2019 CO2
    %%%%%% refer 3: 2001 case with 2019 Tair
    %%%%%% refer 4: 2001 case with 2019 PP
    %%%%%% refer 5: 2001 case with 2019 VPD
    %%%%%% refer 6: 2001 case with 2019 SW.

tmp_grass_avg = squeeze(nanmean(grassy_per(:,:,1:19),3)); % 100%

opt_C4_coverage_refs = 1/(exp(coef_a*opt_AC4_AC3_ratio_refs+coef_b)+1);
opt_C4_coverage_refs(opt_C4_coverage_refs>1) = 1;
opt_C4_coverage_refs(opt_C4_coverage_refs<0) = 0;

for rr = 1:5 % CO2 Tair PP VPD SW

    c4_grass_change(:,:,rr) = tmp_grass_avg.*opt_C4_coverage_refs(:,:,rr) - tmp_grass_avg.*opt_C4_coverage(:,:,9); % 2019 with a factor - 2001 normal estimates)

end

area_record_change(1:5) = squeeze(nansum(nansum(c4_grass_change.*h_area2,1),2))./total_land;


for rr =1:3 % maize, millet, sorghum
    c4_crop_change(:,:,rr) = squeeze(c4_crop_area(:,:,14)).*squeeze(C4_type_crop_ratio(:,:,end,rr)) - squeeze(c4_crop_area(:,:,1)).*squeeze(C4_type_crop_ratio(:,:,end-14,rr)); % need to adjust year 1961-2014
end

area_record_change(6) = NaN;
area_record_change(7:9) = squeeze(nansum(nansum(c4_crop_change.*h_area2,1),2))./total_land;

hold on;
b = bar(area_record_change([1,2,4,5,6,7,8,9]),'FaceColor',[166 206 227]/255,'EdgeColor','none');
b(1).FaceColor = 'flat';

for i = 1:4 % C4 grass
    b(1).CData(i,:) = [190,174,212]./255;
end

for i = 6:8 % crop
    b(1).CData(i,:) = [253,192,134]./255;
end

b(1).EdgeColor = 'flat';
b(1).LineWidth = 1.5;

hold on;
set(gca, 'box', 'off');

factor_names2 = {'CO2';...
    'Tair';'VPD';'SM';...
    ' '; 'Maize';'Millet';'Sorghum'};

ylabel({'C_4 area abundance'; 'change (%)'},'FontSize',10);
ylim([-1.5 1]);
h = gca;
h.XTick = 1:length(factor_names2);
h.XTickLabel = factor_names2;
h.XTickLabelRotation = 45;
h.FontSize = 9;
h.TickLabelInterpreter = 'none';

text(0.2,0.6,strcat('(',char(96+6),')'),'fontsize',10);


set(f3,'PaperPositionMode','auto');
print([output_dir, '/c4_Figure_3'],'-djpeg','-r600');
saveas(gcf,[output_dir, '/c4_Figure_3.pdf']);

%%%%%%%% End: Figure 3. Changes in C4 distribution from 2001 to 2019 %%%%%%%%%%%%%%%





%%%%% Start: Figure 4 the emergent constraint and C4 contribution to global GPP %%%%%%%%%
f4=figure('Name','model C4 distribution','Units', 'centimeters','Color','white', 'Position', [2, 2, 20, 10], ...
    'OuterPosition', [2, 2, 15, 15]);

% sub_panel figure
SpacingVert = 0.15;
SpacingHoriz = 0.1;
MR = 0.05;
ML = 0.1;
MarginTop = 0.05;
MarginBottom = 0.05;


% Panels (a), (b): the two emergent constraints, one for grass, one for crop

for ff = 1:2 

    switch ff
        case 1 % for grass
            xdata = dgvm_c4_grass_1D;
            ydata = dgvm_c4_grass_gpp_1D;
            emergent = nanmean(area_record(:,2))./100;
            stde = nanmean(area_record_un(:,2))./100;
            type = 'C_4 natural grasses';

        case 2 % for crop
            xdata = dgvm_c4_crop_1D;
            ydata = dgvm_c4_crop_gpp_1D;
            emergent = nanmean(area_record(:,3))./100;
            stde = nanmean(area_record_un(:,3))./100;
            type = 'C_4 crops';
    end


    % plot the emergent constraint.
    cd(code_data_dir);
    subaxis(2,2,ff,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom + 0.12); 
    
    hold on;
    shadedColor = [0.9 0.9 0.9];
    plot(xdata,ydata,'.','MarkerSize',20)
    
    % get the linear regression
    x = xdata;
    y = ydata;
    indX=isnan(x);
    x(indX)=[];y(indX)=[];
    %[poly, S] = polyfit(x,y,1);

    cd([code_data_dir,'/polyfitZero-1.3']); % regression with intercept of 0.
    [poly,S,mu] = polyfitZero(x,y,1);
    poly(1,1) = nanmean(y)./nanmean(x);

    
    disp(poly); disp(nanmean(y)./nanmean(x));disp(emergent);disp(nanmean(y));
    slightExt = 0.05;
    x2 = (min(x)-slightExt):0.01:(max(x)+slightExt);
    xfit = x2;
    alpha = 0.05;	% 95% CI Significance level
    [Y,DELTA] = polyconf(poly,xfit,S,'alpha',alpha,'simopt','off','predopt','curve');

    sd_se = sqrt(length(x));
    hconf = plot(xfit,Y+DELTA./sd_se,'r--');
    plot(xfit,Y-DELTA./sd_se,'r--');
    
    hold on;
    cd(code_data_dir);
    shadedplot(xfit, Y+DELTA./sd_se, Y-DELTA./sd_se, [1 0.7 0.7],'none');
    yfit = polyval(poly,xfit);

    hold on;
    p(2)=plot(x2,yfit,'r-','LineWidth',1);
    
    % add the VERTICAL shaded area
    shaded_x1 = emergent -stde;
    shaded_x2= emergent + stde;
    shaded_maxy = 1;%polyval(poly,emergent);
    ha = area([shaded_x1 shaded_x2], [shaded_maxy shaded_maxy] ,'FaceColor',shadedColor,'LineStyle','none');
    ha.FaceAlpha = 0.6;

    % add the vertical line
    y1a=1;
    p(1)=plot([emergent emergent],[0 y1a],'k--');
    
    % add the horizontal emergent constraint line
    x1a=[0 emergent];
    y1a=polyval(poly,emergent);
    p(1)=plot(x1a,[y1a y1a],'k--');
    
    hold on;
    plot(xdata,ydata,'k.','MarkerSize',15)
    
    % the statisical strength of emergent constraint
    [r,p] =corrcoef(xdata,ydata,'rows','complete');
    r_text1 = strcat('r^2=',{' '},num2str(round(r(1,2)^2,2)));
    r_text2 = strcat('p=', num2str(round(p(1,2),3)));
    r_text3 = strcat('y=',num2str(round(poly(1),2)),'x');
    r_text = {r_text1{:};r_text2;r_text3};
    text(0.06,0.30,r_text,'FontSize',10)
    
    % the labels
    xlabel('Percentage of Area (%)','FontSize',10);
    ylabel('Percentage of GPP (%)','FontSize',10);

    text(0.01,0.42,strcat('(',char(96+ff),')',{' '},type),'FontSize',10);

    hold on;
    disp(emergent.*poly(1));

    ylim([0 0.45]);
    xlim([0 0.23]);

    h = gca;
    h.XTickLabel = {'0','5','10','15','20'};
    h.YTickLabel = {'0','10','20','30','40'};
end



% Panel (c): changes in emergent constraint over time
% the data were acquired from calculating EC for every year of TRENDY DGVMs ensemble from 2001 to 2019. The data is stored in constraint_slope and constraint_slope_un.
facecolor =  [127,201,127;...
            190,174,212;...
            253,192,134]./255;

year_range = [2001:2019]';

cd(code_data_dir);
subaxis(2,2,3,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML+0.03,'MarginTop',MarginTop,'MarginBottom',MarginBottom + 0.12); 

% constraint for C4 grass, for 2001 to 2019
pxx1=plot(year_range,movmean(constraint_slope(:,1),5),'-','LineWidth',1,'color',facecolor(2,:),'DisplayName','C4 grass');
hold on;

h=fill([year_range; flip(year_range)], [movmean(constraint_slope(:,1),5) - movmean(constraint_slope_un(:,1),5); flip(movmean(constraint_slope(:,1),5) + movmean(constraint_slope_un(:,1),5))], facecolor(2,:));
set(h,'facealpha',.2);
set(h,'LineStyle','none');
hold on;

% constraint for C4 crop, from 2001 to 2019
pxx2=plot(year_range,movmean(constraint_slope(:,2),5),'-','LineWidth',1,'color',facecolor(3,:),'DisplayName','C4 crop');
hold on;

h=fill([year_range; flip(year_range)], [movmean(constraint_slope(:,2),5) - movmean(constraint_slope_un(:,2),5); flip(movmean(constraint_slope(:,2),5) + movmean(constraint_slope_un(:,2),5))], facecolor(3,:));
set(h,'facealpha',.2);
set(h,'LineStyle','none');
hold on;

ylabel({'Emergent constraint'; 'coefficients (GPP/area)'},'FontSize',10)
xlabel('Year');
ylim([1.05 1.22]);
xlim([2001 2019]);

text(2001,1.23,strcat('(',char(96+3),')'),'FontSize',10);

% Panel (d): the contribution of C4 to global GPP.
cd(code_data_dir);
subaxis(2,2,4,'SpacingVert',SpacingVert,'SpacingHoriz',SpacingHoriz,'MR',MR,'ML',ML,'MarginTop',MarginTop,'MarginBottom',MarginBottom + 0.12); 
    
total_GPP_per = area_record(:,2).*constraint_slope(:,1) + area_record(:,3).*constraint_slope(:,2);
total_C4_grass_GPP_per = area_record(:,2).*constraint_slope(:,1);
total_C4_crop_GPP_per = area_record(:,3).*constraint_slope(:,2);

total_GPP_per_un = area_record_un(:,2).*(constraint_slope(:,1) +  2.*constraint_slope_un(:,1)) + area_record_un(:,3).*(constraint_slope(:,2) + 2.*constraint_slope_un(:,2));
total_C4_grass_GPP_per_un = area_record_un(:,2).*(constraint_slope(:,1) +  2.*constraint_slope_un(:,1));
total_C4_crop_GPP_per_un = area_record_un(:,3).*(constraint_slope(:,2) + 2.*constraint_slope_un(:,2));

% plot total GPP, C4 grass gpp, C4 crop gpp with uncertainty
hold on;
pxx1=plot(year_range,total_GPP_per,'-','LineWidth',1,'color',facecolor(1,:),'DisplayName','C4');
h=fill([year_range; flip(year_range)], [total_GPP_per - total_GPP_per_un; flip(total_GPP_per + total_GPP_per_un)], facecolor(1,:));
set(h,'facealpha',.2);
set(h,'LineStyle','none')


pxx2=plot(year_range,total_C4_grass_GPP_per,'-','LineWidth',1,'color',facecolor(2,:),'DisplayName','C4 grass');
h=fill([year_range; flip(year_range)], [total_C4_grass_GPP_per - total_C4_grass_GPP_per_un; flip(total_C4_grass_GPP_per + total_C4_grass_GPP_per_un)], facecolor(2,:));
set(h,'facealpha',.2);
set(h,'LineStyle','none');

pxx3=plot(year_range,total_C4_crop_GPP_per,'-','LineWidth',1,'color',facecolor(3,:),'DisplayName','C4 crop');
h=fill([year_range; flip(year_range)], [total_C4_crop_GPP_per - total_C4_crop_GPP_per_un; flip(total_C4_crop_GPP_per + total_C4_crop_GPP_per_un)], facecolor(3,:));
set(h,'facealpha',.2);
set(h,'LineStyle','none');

ylabel('% of global GPP','FontSize',10)
xlabel('Year');
ylim([0 25]);
xlim([2001 2019]);
text(2001,26.5,strcat('(',char(96+4),')'),'FontSize',10);


legend([pxx1,pxx2,pxx3],{'C_4','C_4 natural grasses','C_4 crops'},'Orientation','horizontal','Position',[0.22    0.00    0.7    0.075],'Box','off');


set(f4,'PaperPositionMode','auto');
print([output_dir, '/c4_Figure_4'],'-djpeg','-r600');
saveas(gcf,[output_dir, '/c4_Figure_4.pdf']);

%%%%% End: Figure 4 the emergent constraint and C4 contribution to global GPP %%%%%%%%%
