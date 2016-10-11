addpath(genpath('./dependencies/'));
addpath('./lib/');
addpath('./scripts');

font_size = 16;

set(groot, 'DefaultAxesTickLabelInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
% set(groot, 'DefaultTitleInterpreter', 'latex');
set(groot, 'defaulttextinterpreter', 'latex');
set(gca, 'Color', 'none'); % Sets axes background
set(gca, 'fontsize', font_size)

colors = brewermap(9, 'Set1');
set(0,'DefaultAxesColorOrder', colors);
set(0, 'DefaultLineMarkerSize',  8);
set(0, 'DefaultLineLineWidth', 1.6);
set(0,'DefaultAxesFontSize', font_size);
set(0,'DefaultLegendFontSize', font_size);
set(0,'DefaultTextFontSize', font_size);
set(0, 'DefaultAxesLineWidth', 0.75);
% set(0, 'DefaultLegendColor', 'none');
% set(0, 'DefaultAxesFontWeight', 'bold')
format long;
