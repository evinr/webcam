// Triggered Image Copying in S3 Bucket via a Lambda Function
// 
// This function should be called after an image is uploaded to an S3 bucket
// It should take the image that was just uploaded and then copy that image to a dedicated directory that will hold all of the images that are being captured regularly
	exports.handler = function(event, context, callback) {
		var AWS = require('aws-sdk');
		    AWS.config.update({accessKeyId: process.env.accessKeyId, secretAccessKey: process.env.secretAccessKey});
		var s3 = new AWS.S3();
		var now = new Date().toISOString().slice(0,16).replace(/[-T:]/g,""); // Date in YYYYMMDDHHmm format
		var bod = event.body;
		var params = {
				Bucket: 'photobad.com',
				// assumes it will always be jpeg
				// TODO: Determine if a path is allowed to be feed in like this
				Key: 'images/' + now + '.jpeg',
				Body: new Buffer(event.base64String, 'base64')
			};

		s3.putObject(params, function(err, data) {
			if (err) {
			    callback(null, 'an error occured ' + err);
			}
			// if the file object is uploaded successfully to s3 then you get your full url back
			callback(null, 'all good ' + params.Key);

		})
	}