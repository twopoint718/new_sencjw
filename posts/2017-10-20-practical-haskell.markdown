---
title: Practical Haskell
---

Alternate title: _A Haskell Talk That Would Definitely Be Rejected At a Functional Programming Conference_

First, for some background context, please go read [Haskell Success Stories][snoyman2017].

[Snoyman2017]: https://www.snoyman.com/blog/2017/04/haskell-success-stories

While it's not true, there's the perception out there that Haskell's only good for doing math-y things.
Got some high-finance doohickey that you need to write?
Sure.
Do you need to write a [Boring Line-of-business Application][]?
Not so much.
There are bits and pieces out there, but it can be tough to bring them together.
Sometimes what you see is a novel encoding of a known problem but in a functional context.
Like it could be show-and-tell about a functional data structure (many great articles fall into this category).
Others are about getting a grip on some advanced technique, e.g. _free monads_, _lenses_, _profunctors_, etc.
I love these sorts of articles!
But others have written many and have written them much better than I could.
I want to put out a few articles on how to accomplish some meat-and-potatoes software tasks.

[Wlaschin2014]: http://fsharpforfunandprofit.com/ddd/

The three avenues I used when I started learning Haskell were: "Real World Haskell," flailing around in the REPL endlessly, and reading blog posts.
Maybe more than other languages, Haskell has a _distributed tutorial_ that comprises a vast collection of programming blog posts _out there._
Collectively, these make up a lot of _The Literature_.

One thing that I want to add to that corpus is _my take_ on writing day-to-day Haskell code.
This is the kind of thing that probably seems super mundane and not interesting to many Haskellers, and that's okay.
My audience here is people who have the impression that you can write a compiler with Haskell, but you can't send an email.
They may think Haskell is "good" but the unsaid follow-on thought is "...for problems I don't have."
In blabbing about how I do some of those ordinary things, I want that person to come away thinking: "oh, it's nice for my _regular_ problems, too."

I'm hoping that this will be a series of posts where I can show several examples.
The first one on the docket is something that always sort of bugged me in Ruby on Rails: "Job Scheduling."
Wikipedia has a [longish page][Wiki] about all the forms that that problem can take, but what I had in mind is the prototypical [Sidekiq][Sidekiq] app.
If you've never met Sidekiq it's a job queuing system that uses Redis to persist descriptions of "jobs" to run.
Later, in an entirely different _OS process_, Sidekiq pops jobs off the queue and then runs them.

[Wiki]: https://en.wikipedia.org/wiki/Job_scheduler
[Sidekiq]: http://sidekiq.org/

This is a pretty common thing for _The Business_ to want.
There are lots of tasks that need to get done but they don't need to get done _now_.
It is perfectly fine to push them off to the side and continue with some other workflow.
This makes a lot of sense.
The garden-variety Rails web application would get bogged down if it had to run a lengthy, I/O-intensive side-quest in the middle of a controller action.
Enqueuing a job is a quick process, so that the synchronous web request can complete.
Once a job is scheduled, a worker from the pool will pick it up anon.

Let's build a toy version of that.


## JobScheduler.hs - Queue Management


It's been said that [an idiomatic Haskell program is 20 lines of imports, 6 language extensions, and 1 line of Perl][Gonzalez2016].
I cut through that thicket with a custom prelude, `Preamble`.
You can go check it out if you'd like, but it's just there to import and then re-export common libraries.
Let's start with some bookkeeping that we need for working with the queue itself:

[Gonzalez2016]: https://twitter.com/gabrielg439/status/701871069607505921 

```haskell
--------------------------
-- Data types


type Task = Maybe JobParser.JobSpec
type JobQueue = TChan Task


--------------------------
-- Functions


-- | Start up a worker pool of 'k' members. Return the 'TChan' that can be
-- used to assign work to the pool.
init :: Int -> IO JobQueue
init k = do
    reportQueue <- newTChanIO
    jobQueue <- newTChanIO

    -- start the report writer worker listening on the reportQueue
    _ <- forkIO (reportWriter reportQueue)

    -- start worker threads 1 through k, all listening on the jobQueue
    forM_ [1..k] $ \workerNum ->
        forkIO (worker reportQueue jobQueue workerNum)

    -- return the jobQueue (so we can add jobs to it later)
    return jobQueue


-- | Spam 'Nothing' task into the job queue. When a worker receives a
-- 'Nothing' 'Task', it will quit.
shutdown :: Int -> JobQueue -> IO ()
shutdown k jobQueue = atomically $
    replicateM_ k (writeTChan jobQueue Nothing)


-- | Add a job to the queue specified by a 'JobParser.JobSpec'.
enqueue :: MonadIO m => JobParser.JobSpec -> JobQueue -> m ()
enqueue jobSpec jobQueue = liftIO . atomically $
    writeTChan jobQueue (Just jobSpec)
```

`init` creates the `JobQueue` itself and spawns `k` workers to watch the output of that queue.
We're using a `TChan Task` (a transactional channel that can carry `Task` values).
This is a lot like a [Golang channel][GoChan] except we additionally get transactional semantics around the reading and writing of the channel.
For instance, we could read from one channel and write to another and wrap the whole thing in `atomically`.
Outside of that block we'd only be able to observe both happen or neither happen.
We also create a `reportQueue`/`reportWriter` which will asynchronously collect log messages and print them to the terminal.

[GoChan]: https://gobyexample.com/channels 

`shutdown` sends `k` _quit_ messages to the worker pool.
When a worker receives a `Nothing` value, it'll quit.
This will terminate that worker's thread.

Lastly, `enqueue` writes a new job into the `jobQueue`.
We'll talk more about what a `JobSpec` is in a minute, but it's really just a description of a job to run.
We need to wrap the `jobSpec` in `Just` to distinguish it from `Nothing`, which would kill the worker thread.


## JobScheduler.hs - Workers and Jobs


Now that we've got our queue all prepped, we can handle jobs that come down the pike.

```haskell
-- | Watch the report queue for messages and write them to the terminal
reportWriter :: TChan String -> IO ()
reportWriter chan =
    forever $ do
        msg <- atomically (readTChan chan)
        putStrLn msg
        hFlush stdout


-- | Run a worker. It can write to the report queue and it can read from the
-- jobQueue. It is also assigned a sequential number as a label, so we
-- know it's "worker 1," for example. The actual job is done in the
-- 'performJob' helper. This prints the job's name from the 'JobSpec'
-- and then waits the given duration in seconds. Then it prints that
-- it's finished.
worker :: TChan String -> JobQueue -> Int -> IO ()
worker reportQueue jobQueue workerNum = loop
    where
        loop = do
            job <- atomically (readTChan jobQueue)
                case job of
                    Nothing -> return ()
                    Just spec  -> do
                        performJob spec reportQueue workerNum
                        loop


-- | Actually perform the specified job. In this case we just sleep for
-- however long the job specifies.
performJob :: JobParser.JobSpec -> TChan String -> Int -> IO ()
performJob (JobParser.JobSpec name duration) reportQueue workerNum = do
    let startMsg = printf "WORKER %d STARTING JOB: %s" workerNum name
        finishMsg = printf "WORKER %d FINISHED: %s" workerNum name
    atomically (writeTChan reportQueue startMsg)
    threadDelay (1000000 * duration)
    atomically (writeTChan reportQueue finishMsg)
```

I mentioned briefly that we have a (sort of) parallel work queue for logging messages.
This is the worker that deals with that queue.
`reportWriter` loops forever, pulling `String` messages off the queue and writing them to the terminal.
This seems trivial, but if we logged directly from the worker threads we'd sometimes get some Zalgo text instead of a sensible message.
The threads could interleave in any order.
We sidestep this by writing messages into a channel and then printing them in an orderly fashion.

The `worker` is the central figure on stage.
We bring together the `jobQueue`, the `reportQueue`, an `Int` (for identifying the worker, not really needed, but nice for logging), and handle jobs coming in through the queue.
We loop forever pulling jobs off the queue.
If the job's value is `Nothing` then we'll yield a value rather than looping again, this ends the thread.
Otherwise, we extract the `JobSpec` and pass the resulting payload along to `performJob`.
We then loop again.

`performJob` opens up the payload and performs the job.
In my simulation here, the "job" such as it is, is just a number.
This code announces to the world that it's starting work, sleeps for that number of seconds, and then announces it's done[^1].

[^1]: The _modus operandi_ of the ideal programmer, amirite?


## JobParser.hs


Jobs are sent to the server in simple XML format like so:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<job>
  <jobName>10-second job</jobName>
  <seconds>10</seconds>
</job>
```

JSON it ain't, but I wanted to make this more Enterprisey, right?
So let's extract the juicy business data inside:

```haskell
-- | The job spec is the name and the duration of the job. Nothing too
-- weird. The duration is converted into an 'Int'.
data JobSpec = JobSpec
    { jobName     :: String
    , jobDuration :: Int
    }


-- | We convert from 'XmlSource' which has instances for various
-- text-ual type things: 'String', 'ByteString', 'Text', etc. If parsing
-- succeeds we'll end up with a 'JobSpec'. 
parseJob :: Lexer.XmlSource s => s -> Maybe JobSpec
parseJob s = XML.parseXMLDoc s >>= getJob


-- | Extract the "jobName" and "seconds" fields out of the XML document.
getJob :: XML.Element -> Maybe JobSpec
getJob el = liftA2 JobSpec
    (XML.strContent <$> XML.filterChildName (byName "jobName") el)
    (read . XML.strContent <$> XML.filterChildName (byName "seconds") el)


-- | A helper function that will search by the name of the tag (rather
-- than attributes or other XML-y things).
byName :: String -> XML.QName -> Bool
byName needle haystack = XML.qName haystack == needle
```

If you're used to looking at parsing type code that shouldn't look too different.
Haskell's typical style is to have a functon amounting to `TextBlob -> Maybe BusinessBlob` somewhere.
Even if this function is internally complex, the exterior API will examine unstructured input and give a thumbs up or down.
The nice part about this, once you've tested your parser reasonably well, is that once input text passes muster then you don't have to worry about it any longer.
You go from opaque blob directly to a business domain object[^2] _or_ a reason why you couldn't.

[^2]: In reality, you'll probably go to a [DTO][DTO] rather than an internal domain datatype directly.
    Also, to be very clear I'm using _object_ in a lowercase discussion kind of way and not an uppercase UML kind of way.

[DTO]: https://en.wikipedia.org/wiki/Data_transfer_object


## Web.hs - Putting it Together


We tie the job queue together with the job specs by allowing them to be submitted via a POST.
We have two routes, a bogus one just to make sure the webapp is up -- if you like that sort of thing.
The action happens when someone POSTS an XML JobSpec to `/upload`:

```haskell
app :: JobScheduler.JobQueue -> Scotty.ScottyM ()
app jobQueue = do
    Scotty.get "/" $
        Scotty.text "hello"

    -- upload action
    Scotty.post "/upload" $ do
        maybeJobSpec <- withUploadedFile JobParser.parseJob
        maybeJobSpec `or400` \jobSpec -> do
            JobScheduler.enqueue jobSpec jobQueue
            Scotty.status _200


withUploadedFile :: (BL.ByteString -> Maybe a) -> Scotty.ActionM (Maybe a)
withUploadedFile f = do
    files <- Scotty.files
    case files of
        [] -> do                               -- no files uploaded
            Scotty.status _422
            return Nothing
        ((_, fileInfo):_) ->                   -- at least one file
            return (f (fileContent fileInfo))


or400 :: Maybe a -> (a -> Scotty.ActionM ()) -> Scotty.ActionM ()
or400 m f = maybe (Scotty.status _400) f m
```

First we try to extract an uploaded file from the HTTP POST.
`withUploadedFile` is a helper function that takes care of this pattern.
It rummages around where the uploaded files ought to be, if there are any, and returns a 422 status if one wasn't found.
If it does find at least one file then we extract the `fileContent` from that payload and pass it to the callback function, `f`.
This function should expect to receive a `ByteString` and maybe return some value.

Back in the _upload action_, we use this to compose the pedestrian workflow of "receive upload, check if it was _really_ an upload, and then parse it, if indeed it's parseable."
We use `or400` to handle the case when we couldn't parse the XML, responding with an HTTP 400 if so.
Otherwise, we have a real-live `jobSpec`.
We `enqueue` it in the `jobQueue` and then respond with an HTTP 200.


## Main.hs - starting the queue and web server


Last thing to do is to start the thing!

```haskell
main :: IO ()
main =
  bracket (JobScheduler.init 4) (JobScheduler.shutdown 4) $ \jobQueue ->
    scotty 8000 (Web.app jobQueue)
```

We're using `bracket` to make sure that the job queue is properly started and cleaned up in case we abort somewhere.
The pattern is that `init` returns the _resource_ (`JobQueue`)
`shutdown 4` has the, partially-applied, type `JobQueue -> IO ()`.
And the inner _action_ is a function of `jobQueue` as well.

```
bracket :: IO a -> (a -> IO b) -> (a -> IO c) -> IO c
           ^^^^^   ^^^^^^^^^^^    ^^^^^^^^^^^
             |          |              '- use
             |          '- clean up
             `- Acquire resource
```

And then we start the web app, passing in the `jobQueue` so that it's available within.
There you have it!


## Running the "simulation"


Let's take it for a spin.
I'll fire off a bunch of jobs and see how the system responds:

```bash
for file in `ls *xml`
do
	curl -XPOST -F "upload=@${file}" http://127.0.0.1:8000/upload
	sleep 1
done
```

This submits each the five sample jobs at a 1 second interval.
It isn't that important, but I thought the simulation should suggest that new jobs can arrive at any time.
And then we can check on the server to see how they've been processed:

```
WORKER 4 STARTING JOB: 10-second job
WORKER 1 STARTING JOB: 15-second job
WORKER 3 STARTING JOB: 20-second job
WORKER 2 STARTING JOB: 2-second job
WORKER 2 FINISHED: 2-second job
WORKER 2 STARTING JOB: 5-second job
WORKER 4 FINISHED: 10-second job
WORKER 2 FINISHED: 5-second job
WORKER 1 FINISHED: 15-second job
WORKER 3 FINISHED: 20-second job
```

An interesting thing to note is that there are 5 jobs but only 4 workers.
We can see this in the trace.
When WORKER 2 finishes the 2-second job, the 5-second job is waiting in the queue.
WORKER 2 then picks up the 5-second job and continues.
These jobs are on a simple fixed timer, but you could imagine each job taking a variable amount of processing time before finishing.


## Full example

You can check out the full code here: <https://github.com/twopoint718/job-scheduler>
