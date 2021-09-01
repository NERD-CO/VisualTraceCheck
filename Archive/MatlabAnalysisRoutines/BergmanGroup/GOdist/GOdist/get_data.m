function [B1_S,B1_D,B2_S,B2_D,E1_S,E1_D,E2_S,E2_D] = get_data(B,E,paramnames,params);

switch B
    case 'F'
        B1_S = get_param_values('F1_Signal',paramnames,params);
        B1_D = get_param_values('F1_Detection',paramnames,params);
        B2_S = get_param_values('F2_Signal',paramnames,params);
        B2_D = get_param_values('F2_Detection',paramnames,params);
    case 'S'
        B1_S = get_param_values('S1_Signal',paramnames,params);
        B1_D = get_param_values('S1_Detection',paramnames,params);
        B2_S = get_param_values('S2_Signal',paramnames,params);
        B2_D = get_param_values('S2_Detection',paramnames,params);
    case 'R'
        B1_S = get_param_values('R1_Signal',paramnames,params);
        B1_D = get_param_values('R1_Detection',paramnames,params);
        B2_S = get_param_values('R2_Signal',paramnames,params);
        B2_D = get_param_values('R2_Detection',paramnames,params);
    case 'FM'
        B1_S = get_param_values('FM1_Signal',paramnames,params);
        B1_D = get_param_values('FM1_Detection',paramnames,params);
        B2_S = get_param_values('FM2_Signal',paramnames,params);
        B2_D = get_param_values('FM2_Detection',paramnames,params);
    case 'SM'
        B1_S = get_param_values('SM1_Signal',paramnames,params);
        B1_D = get_param_values('SM1_Detection',paramnames,params);
        B2_S = get_param_values('SM2_Signal',paramnames,params);
        B2_D = get_param_values('SM2_Detection',paramnames,params);
    case 'RM'
        B1_S = get_param_values('RM1_Signal',paramnames,params);
        B1_D = get_param_values('RM1_Detection',paramnames,params);
        B2_S = get_param_values('RM2_Signal',paramnames,params);
        B2_D = get_param_values('RM2_Detection',paramnames,params);
end

switch E
    case 'F'
        E1_S = get_param_values('F1_Signal',paramnames,params);
        E1_D = get_param_values('F1_Detection',paramnames,params);
        E2_S = get_param_values('F2_Signal',paramnames,params);
        E2_D = get_param_values('F2_Detection',paramnames,params);
    case 'S'
        E1_S = get_param_values('S1_Signal',paramnames,params);
        E1_D = get_param_values('S1_Detection',paramnames,params);
        E2_S = get_param_values('S2_Signal',paramnames,params);
        E2_D = get_param_values('S2_Detection',paramnames,params);
    case 'R'
        E1_S = get_param_values('R1_Signal',paramnames,params);
        E1_D = get_param_values('R1_Detection',paramnames,params);
        E2_S = get_param_values('R2_Signal',paramnames,params);
        E2_D = get_param_values('R2_Detection',paramnames,params);
    case 'FM'
        E1_S = get_param_values('FM1_Signal',paramnames,params);
        E1_D = get_param_values('FM1_Detection',paramnames,params);
        E2_S = get_param_values('FM2_Signal',paramnames,params);
        E2_D = get_param_values('FM2_Detection',paramnames,params);
    case 'SM'
        E1_S = get_param_values('SM1_Signal',paramnames,params);
        E1_D = get_param_values('SM1_Detection',paramnames,params);
        E2_S = get_param_values('SM2_Signal',paramnames,params);
        E2_D = get_param_values('SM2_Detection',paramnames,params);
    case 'RM'
        E1_S = get_param_values('RM1_Signal',paramnames,params);
        E1_D = get_param_values('RM1_Detection',paramnames,params);
        E2_S = get_param_values('RM2_Signal',paramnames,params);
        E2_D = get_param_values('RM2_Detection',paramnames,params);
end

