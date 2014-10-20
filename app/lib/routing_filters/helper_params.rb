module RoutingFilter
  class HelperParams < Filter
    HELPER_PARAMS = [:full_page, :_, :i_req_id, :format]

    def around_recognize(path, env, &block)
      yield
    end

    def around_generate(params, &block)
      HELPER_PARAMS.each { |param| params.delete(param) }
      yield
    end
  end
end
