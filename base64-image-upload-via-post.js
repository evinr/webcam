// Image Storage in a S3 Bucket via a Lambda Function
// 
// the JSON is sent via POST request to via the gateway and assumes the image is encoded as a string assigned to the attribute named base64String 
// This catches the image being transmitted via POST
// copy and paste the contents via the AWS Lambda console or upload the entire zip to AWS Lambda
	exports.handler = function(event, context, callback) {
		var AWS = require('aws-sdk');
		    AWS.config.update({accessKeyId: process.env.accessKeyId, secretAccessKey: process.env.secretAccessKey});
		var s3 = new AWS.S3();
		var now = new Date().getTime();
		var bod = event.body;
		var params = {
				Bucket: 'photobad.com',
				// assumes it will always be jpeg
				Key: 'default.jpeg',
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