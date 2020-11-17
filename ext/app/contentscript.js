const l = console.log;

browser.runtime.onMessage.addListener(async function(m) {
    l('message in',m);
    const {message,url}=m;
    switch (message) {
    case 'scrape-in-place':
	if (url!==location.href) {
	    l(url,location.href);
	    throw new Error('scrape in place on mismatching url');
	}
	if (!document.querySelector('#gr_txtdownload'))
	{
	    l('contents to collect are here');
	    //assuming we are in text view mode
	    browser.runtime.sendMessage({message:'contents',
					 body:document.body.outerText,
					 url:location.href});
	}
	else
	{
	    browser.runtime.sendMessage({message:'details',
					 title:/(.+)"/.exec(document.querySelector('.info-download__title').textContent)[1],
					 url:location.href,
					 videoDownloadLink:document.querySelector('#gr_mp4download').href
					});

	    l('got buttons to push');
	    document.querySelector('#downloadCommentPhrase').click();
	    document.querySelector('#downloadCommentText').click();
	    document.querySelector('#gr_txtdownload').click();
	}

	break;
    case 'goto':
	location.href=m.url;
	break;
    default:
	throw new Error('unknown message');
    }
});
async function logic() {
    browser.runtime.sendMessage({
        message:'am-at',
        url:location.href,
    });
}
logic();

