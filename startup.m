addpath(genpath('./dependencies/'));
addpath('./lib/');
addpath('./scripts');

set(groot, 'DefaultAxesTickLabelInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
% set(groot, 'DefaultTitleInterpreter', 'latex');
set(groot, 'defaulttextinterpreter', 'latex');
set(gca, 'Color', 'none'); % Sets axes background

colors = brewermap(9, 'Set1');
set(0,'DefaultAxesColorOrder', colors);
set(0, 'DefaultLineMarkerSize',   7);
set(0, 'DefaultLineLineWidth', 1);
format long;
