if defined?(RuntimeerrorNotifier)
  RuntimeerrorNotifier.for ENV['RUNTIMEERROR_EMAIL']
  RuntimeerrorNotifier::Notifier::IGNORED_EXCEPTIONS.push(*%w[
    ActionController::RoutingError
  ])
end
