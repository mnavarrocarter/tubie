Docs here: https://developers.google.com/youtube/v3/guides/using_resumable_upload_protocol

I have to open a file with File.load_contents
When you read a file you kinda move your cursor around the file
In the FileIOStream class there's a method called seek, that i can use
to start to read the file from a specific byte. i can use that to resume the
upload process.

file.new_by_path(filepath)
session.send_message(message)
session.on_chunk_sent() {
     message.append_body(partoffile)
}
 


After Authentication, i need to send a POST to Google to
start a resumable session. 
 
Async: Then i need to PUT the video in the URI response they sent me back.
Video data must be in binary
   
I can check the status in the meantime.
    
If it fails, you can resume PUTing to the same URI they gave me.