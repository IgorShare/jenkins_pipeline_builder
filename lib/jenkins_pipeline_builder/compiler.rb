#
# Copyright (c) 2014 Igor Moochnick
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

module JenkinsPipelineBuilder
  class Compiler
    def self.resolve_value(value, settings)
      settings = settings.with_indifferent_access
      value_s = value.to_s.clone
      vars = value_s.scan(/{{([^{}]+)}}/).flatten
      vars.select! do |var|
        var_val = settings[var]
        value_s.gsub!("{{#{var.to_s}}}", var_val) unless var_val.nil?
        var_val.nil?
      end
      return nil if vars.count != 0
      return value_s
    end

    def self.get_settings_bag(item_bag, settings_bag = {})
      item = item_bag[:value]
      bag = {}
      return unless item.kind_of?(Hash)
      item.keys.each do |k|
        val = item[k]
        if val.kind_of? String
          new_value = resolve_value(val, settings_bag)
          return nil if new_value.nil?
          bag[k] = new_value
        end
      end
      my_settings_bag = settings_bag.clone
      return my_settings_bag.merge(bag)
    end

    def self.compile(item, settings = {})
      errors = {}
      case item
        when String
          new_value = resolve_value(item, settings)
          if new_value.nil?
            errors[item] =  "Failed to resolve #{item}"
          end
          unless errors.empty?
            return false, errors
          end
          return true, new_value
        when Hash
          result = {}
          item.each do |key, value|
            if value.nil?
              errors[key] = "key: #{key} has a nil value, this is likely a yaml syntax error. Skipping children and siblings"
              break
            end
            success, payload = compile(value, settings)
            unless success
              errors.merge!(payload)
              next
            end
            if payload.nil?
              errors[key] = "Failed to resolve:\n===>key: #{key}\n\n===>value: #{value}\n\n===>of: #{item}"
              next
            end
            result[key] = payload
          end
          unless errors.empty?
            return false, errors
          end
          return true, result
        when Array
          result = []
          item.each do |value|
            if value.nil?
              errors[item] = "found a nil value when processing following array:\n #{item.inspect}"
              break
            end
            success, payload = compile(value, settings)
            unless success
              errors.merge!(payload)
              next
            end
            if payload.nil?
              errors[value] = "Failed to resolve:\n===>item #{value}\n\n===>of list: #{item}"
              next
            end
            result << payload
          end
          unless errors.empty?
            return false, errors
          end
          return true, result
      end
      return true, item
    end
  end
end
