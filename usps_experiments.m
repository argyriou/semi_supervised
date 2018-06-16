mkdir('tests');
test_dir = 'tests';
init;

% Odd vs. even

data_fname = 'usps';
all_str = {'eucl','trans','tang'};
index_fname = 'indexes_oe';
n = 800;
lab = [10,20,30];
distances = all_str;
create_dist_matrices;
create_kernels;
run_convex;
write_results;
for i=1:length(all_str)
    distances = all_str(i);
    run_convex;
    write_results;
end

% Binary tasks

index_fname = 'indexes';
n = 400;
lab = [4,8,12];
for digits = {'23','17','47','27','38'}
    data_fname = sprintf('usps%s',char(digits));
    distances = all_str;
    create_dist_matrices;
    create_kernels;
    run_convex;
    write_results;
    for i=1:length(all_str)
        distances = all_str(i);
        run_convex;
        write_results;
    end
end

% 6 vs. 9

data_fname = 'usps69';
all_str = {'eucl','trans','flip'};
distances = all_str;
create_dist_matrices;
create_kernels;
run_convex;
write_results2;
plot_adjacency;
