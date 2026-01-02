I'm looking for a MCP server and aggregator to run on a local server.

This is a really fast-evolving space, and tools that do something like what I'm looking for can be variously described as proxies, gateways, or routers, among other names. 

My use case is solo use and development - I do a lot of AI development and am also really interested in MCP and exploring it. I use MCP servers on a daily basis (most common ones: transcription and email sending ). Things like advanced federation features intended for creating precise access control functionalities are less useful.

The servers that I want to bundle will straddle local servers as well as remote ones. In the home environment, I have MCP servers running on local devices as well as Home Assistant. Remote MCPs that I use frequently include using Gemini for transcription, File.AI for image generation, Context Seven for context retrieval, and a few others. Ideally, I would like to have all MCP tools gathered together on this one server gateway so that I don't need to ever run local MCPs.

However, in some cases, like the transcription use case I just described, this is currently difficult to achieve because the MCP has to handle file transfer and then pass it up to the remote server. This will probably get easier over time, but it reflects the current state of technology today.

I have already used a couple of MCP aggregators, including Meta MCP. This was really useful and allowed the bundling of different MCP servers. 

It was also very helpful to be able to group different MCP servers into profiles so that I could create ones for work and personal use. However, the challenge remains one of fluidity. If I am working on a personal or work project, I might be able to create different namespaces, but I would still ultimately have to swap out MCP server configurations manually in order to use the different servers.

However, as far as I could see, it didn't have dynamic tool exposure, and I had some issues with runaway process spawning.

I've also tried MCPM, which was a very nice tool, but it only has a CLI. I think it's essential that an MCP manager on a server has a web UI, allowing for easy administration of the resources.

Ideally, tool curation should also be included, although I think the dynamic discovery makes the most sense. The requirement to prune or expose specific tools should be greatly reduced.

## The Problem: Context Pollution

The main reason that I am continuing to look and explore this space is because none of the projects I have looked at so far, to the best of my knowledge, provide any solution to the main challenge in MCP, which is that of context pollution.

The current challenge in MCP, which is the subject of ongoing discussion, is the fact that MCP servers by default present a full tool list to the agent. This means that if the user has multiple MCP servers, each with a substantial array of tools, the agent is flooded with context before the first turn of the conversation.

To my mind, unless an MCP aggregator provides a solution to this challenge, most of the utility is essentially lost. 

While I think there is a lot of value in being able to aggregate MCP servers at one endpoint, my whole idea in using them is to avoid having to manually prune tool usage and MCP servers. 

Probably like many users, MCP has had moments of brilliance for me, but far too much time has been spent setting up servers with different protocols and clients and having to constantly think about tool minimization.

## The Solution: Dynamic Tool Discovery

Therefore, the type of MCP server gateway that I am looking for is one that aligns with the evolving best practice, which is emerging as dynamic tool discovery.

This means that the MCP server may actually only present one tool, listing the resources which are managed in a vector store. The MCP server therefore not only handles tool aggregation but also intelligent routing, totally offloading the burden of having to maintain different endpoint configurations from the user. This is exactly the type of fluid user experience that aligns with my vision of how MCP will and should be.

## Intended Usage

My daily driver for AI development and work at the moment is Claude Code, but I also use a number of different clients. Mostly CLIs, but being able to use these in conversational apps would be just as useful, if not more so.

The general pattern for integrating these aggregators with an MCP client, or a client that supports MCP like Claude Code, is adding them as a single MCP tool. That is the objective.

## Hosting

I can host this local server on Docker. While sometimes I do want to avoid self-hosting, in this case, it makes sense because it will be bundling not only remote servers but also local resources. It can be installed via Docker or anything else that will run on a Linux server.

Things I am always looking to avoid in open-source projects include:
*   Short-lived projects.
*   Projects with only a single maintainer.
*   Projects that are stagnant and haven't been updated.
*   Projects that are buggy.

I have a very long-term view of the utility of MCP and would like to use a robust tool with good backing and perhaps industry support.

Remember that this is a very fast-evolving space. I will provide some repositories and projects that I am looking at and considering, and complement my research with any other tools that I haven't found yet, bearing in mind the specifics of this implementation.

## The Clinchers

The single and specific feature I am chasing is dynamic tool exposure. This requires a deliberate design philosophy in the application. Alignment with the emerging best practices for this would be very advantageous.

Additionally, any gateway that has tried to think about solutions for the challenges in local versus networked MCPs—specifically how to pass data from local computers to a remote MCP and then onto a further server—would be greatly beneficial.

An MCP library for adding existing MCP servers to your configuration is very helpful and is a common feature. API key management is default and expected in most tools.

Finally, streamable HTTP is the emerging standard. SSE is deprecated, so tools should prioritize this.

Support for injecting lightweight but very useful things like date awareness is also very helpful.