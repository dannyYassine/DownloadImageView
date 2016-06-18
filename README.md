# DownloadImageView
UIImageView subclass that downloads its image with a circular progress

        self.imageView1.setDownloadTask(imageURLs[0], progress: { (progress) in
            print(progress)
            }) { (image) in
                
                // Generate subtile fade in animation with new image
                self.imageView1.alpha = 0.0
                self.imageView1.image = image
                UIView.animateWithDuration(0.5, animations: {
                    self.imageView1.alpha = 1.0
                })
                
        }
