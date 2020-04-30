clear
clc

%% load data
load('qeval.mat');

%% Initialization
reward = qevalreward;
[num_state,num_action] = size(reward);
discount_rate = 0.95;
rate_mode = 5; % 1,2,3,4,5

%% Start run
reach_times = 0;
max_reward = 0;
run_times = [];
for run = 1:10
    disp(['Run number: ',num2str(run)]);
    % timer start
    tic;
    % initialize run parameters
    trial = 1;
    start_state = 1;
    end_state = 100;
    Q = zeros(num_state,num_action);
    converge_flag = false;
    % start trial
    while trial <= 3000 && ~converge_flag
        % initialize trial parameters
        k = 1;
        s_k = start_state;
        Q_old = Q;
        % start walk
        while s_k ~= end_state
            % initialize state parameters
            [graph_title,greedy_rate] = selectRate(k,rate_mode);
            lr = greedy_rate;
            if lr < 0.005
                break
            end
            % select action
            a_k = selectAction(Q(s_k,:),greedy_rate,reward(s_k,:));
            % update Q function
            [Q(s_k,a_k),s_k] = UpdateQ(Q,reward,s_k,a_k,lr,discount_rate);
            % update k
            k = k + 1;
        end
        % update trial and flag
        trial = trial + 1;
        converge_flag = convergeCheck(Q_old,Q,0.005);
    end
    toc;
    % calculate the coordinates of optimal policy
    [reach_flag,policy,policy_reward,state_list,label,x,y,total_reward] = optimalPolicy(Q,reward,start_state,end_state,discount_rate);
    if total_reward > max_reward
        max_reward = total_reward;
        max_info = {x,y,label,policy,policy_reward,state_list};
    end
    % update reach times
    if reach_flag == true
        reach_times = reach_times + 1;
        run_times = [run_times toc];
    end
end

%% Draw max reward policy
execution_time=mean(run_times);
axis ij;xlim([0,10]);ylim([0,10]);grid on;hold on;
title({['\gamma = ',num2str(discount_rate),' , Avg.exc.time = ',num2str(execution_time)];graph_title});
x = max_info{1,1};
y = max_info{1,2};
label = max_info{1,3};
policy = max_info{1,4};
policy_reward = max_info{1,5};
qevalstates = max_info{1,6}';
for i = 1:length(max_info{1,1})
    scatter(x(i),y(i),75,label(i*2-1),label(i*2))
end

%% conclusion
disp(['Maximum reward is ' num2str(max_reward)]);
disp(['Average excution time is ', num2str(execution_time)])
disp(['Number of reached runs is ', num2str(reach_times)])
disp(['The state visited ', num2str(qevalstates')])

%% Functions
function [graph_title,rate] = selectRate(k,mode)
    switch mode
        case 1
            rate = 1 / k;
            graph_title = 'Rate = ^{1}/_{k}'; 
        case 2
            rate = 100 / (100 + k);
            graph_title = 'Rate = ^{100}/_{100 + k}'; 
        case 3
            rate = (1 + log(k)) / k;
            graph_title = 'Rate = ^{1 + log(k)}/_{k}'; 
        case 4
            rate = (1 + 5 * log(k)) / k;
            graph_title = 'Rate = ^{1 + 5log(k)}/_{k}'; 
        case 5
            rate = exp(-0.001*k);
            graph_title = 'Rate = e^{-0.001k}'; 
        otherwise
            error('invalid rate decay type');
    end
end

function action = selectAction(Q_s,greedy_rate,action_list)
    valid_action=find(action_list~=-1);
    if any(Q_s)
        % Exploitation
        if rand>=greedy_rate  
            [~,idx] = max(Q_s(valid_action));
            action=valid_action(idx);
        % Exploration
        else           
            rand_idx=find(Q_s(valid_action)~=max(Q_s(valid_action)));
            idx=randperm(length(rand_idx),1); 
            action=valid_action(rand_idx(idx));
        end
    else
        idx=randperm(length(valid_action),1); 
        action=valid_action(idx);
    end 
end

function [Q_cur_sa,s_k_1] = UpdateQ(Q,reward,s,a,lr,d_r)
    switch a
        case 1
            Q_cur_sa=Q(s,a)+lr*(reward(s,a)+d_r*max(Q(s-1,:))-Q(s,a));
            s_k_1=s-1;
        case 2
            Q_cur_sa=Q(s,a)+lr*(reward(s,a)+d_r*max(Q(s+10,:))-Q(s,a));
            s_k_1=s+10;
        case 3
            Q_cur_sa=Q(s,a)+lr*(reward(s,a)+d_r*max(Q(s+1,:))-Q(s,a));
            s_k_1=s+1;
        case 4
            Q_cur_sa=Q(s,a)+lr*(reward(s,a)+d_r*max(Q(s-10,:))-Q(s,a));
            s_k_1=s-10;
    end
end

function flag = convergeCheck(Q1,Q2,t)
    flag = false;
    temp = abs(Q1-Q2);
    if max(temp,[],'all') < t
        flag = true;
        disp('Converged')
    end
end

function [flag,policy,policy_reward,history_state,label,x,y,total_reward] = optimalPolicy(Q,reward,s_state,e_state,d_r)
    [~,policy]=max(Q,[],2);
    s = s_state;
    step = 1;
    total_reward = 0;
    x = [];
    y = [];
    label = [];
    policy_reward = zeros(10,10);
    history_state = [];
    while s~=e_state && policy_reward(mod(s,10),fix(s/10)+1)==0
        history_state = [history_state s];
        x = [x,fix(s/10) + 0.5];
        y = [y,mod(s,10) - 0.5]; 
        switch policy(s)
            case 1
                label = [label,'^b'];
                policy_reward(mod(s,10),fix(s/10)+1) = d_r.^(step-1)*reward(s,1);
                s=s-1;
            case 2
                label = [label,'>b'];
                policy_reward(mod(s,10),fix(s/10)+1) = d_r.^(step-1)*reward(s,2);
                s=s+10;
            case 3
                label = [label,'vb'];
                policy_reward(mod(s,10),fix(s/10)+1) = d_r.^(step-1)*reward(s,3);
                s=s+1;
            case 4
                label = [label,'<b'];
                policy_reward(mod(s,10),fix(s/10)+1) = d_r.^(step-1)*reward(s,4);
                s=s-10;
        end
        step = step + 1;
    end
    if s == 100
        history_state = [history_state s];
        x = [x,9.5];
        y = [y,9.5]; 
        label = [label,'pr'];
        flag = true;
        disp(['End state reached with optimal policy',newline])
    else
        flag = false;
        disp(['End state NOT reached with optimal policy',newline])
    end
    total_reward = sum(policy_reward,'all');
end
