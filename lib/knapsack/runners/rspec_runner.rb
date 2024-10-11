module Knapsack
  module Runners
    class RSpecRunner
      def self.run(args)
        allocator = Knapsack::AllocatorBuilder.new(Knapsack::Adapters::RSpecAdapter).allocator

        Knapsack.logger.info
        Knapsack.logger.info 'Report specs:'
        Knapsack.logger.info allocator.report_node_tests
        Knapsack.logger.info
        Knapsack.logger.info 'Leftover specs:'
        Knapsack.logger.info allocator.leftover_node_tests
        Knapsack.logger.info

        parallel_test_processors = ENV['PARALLEL_TEST_PROCESSORS'] || 1
        parallel_enabled = ENV['PARALLEL_TEST_ENABLED'] == 'true'

        if parallel_enabled
          cmd = %Q[RAILS_ENV=test PARALLEL_TEST_PROCESSORS=#{parallel_test_processors} parallel_rspec -- #{args} --default-path #{allocator.test_dir} -- #{allocator.stringify_node_tests}]
        else
          cmd = %Q[bundle exec rspec #{args} --default-path #{allocator.test_dir} -- #{allocator.stringify_node_tests}]
        end

        exec(cmd)
      end
    end
  end
end
