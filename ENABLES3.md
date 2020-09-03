# Changes to use s3 backend for data
1. Set the values in `.env`
    ```
    DANBOORU_AWS_ACCESS_KEY_ID=example_access_key
    DANBOORU_AWS_SECRET_ACCESS_KEY=example_secret_key
    ```

2. The the following in `config/danbooro_local_config.rb` to overwrite values. Set the bucket, s3 storage domain, and s3 options
    ### Regular override when using s3
    ```
    module Danbooru
        class CustomConfiguration < Configuration
            # Define your custom overloads here

            # Used for backing up images to S3. Must be changed to your own S3 bucket.
            def aws_s3_bucket_name
                "bucket_name"
            end

            #change to "/bucket_name" when using s3 with force_path_style: true or leave as "/" if force_path_style: false when using s3
            def default_base_path
                "/"
            end

            # The method to use for storing image files.
            def storage_manager
                StorageManager::S3.new("bucket_name", base_url: "https://bucket_name.s3.amazon.com/", s3_options: {})
            end
        end
    end
    ```
    ### Override when using s3 with force_path_style enabled
    ```
    module Danbooru
        class CustomConfiguration < Configuration
            # Define your custom overloads here

            # Used for backing up images to S3. Must be changed to your own S3 bucket.
            def aws_s3_bucket_name
                "bucket_name"
            end

            #change to "/bucket_name" when using s3 with force_path_style: true or leave as "/" if force_path_style: false when using s3
            def default_base_path
                "/bucket_name"
            end

            # The method to use for storing image files.
            def storage_manager
                StorageManager::S3.new("bucket_name", base_url: "https://s3.amazon.com/", s3_options: {endpoint: "https://s3.amazon.com/", force_path_style: true})
            end
        end
    end
    ```
3. Uncomment the line and set value in `config/environments/development.rb`
    ```
    config.active_storage.service = :amazon
    ```
4. Add s3 domains in `config/initializers/content_security_policy.rb`
    on the end add the domain used for s3 storage on the following lines 
    ```
    policy.object_src
    policy.media_src
    policy.img_src
    ```