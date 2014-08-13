var curResults;

// Callback for when we recieve data from a search query request
function renderResults(data) {
	curResults = data.results
	$('#resultsTable').find("tr").remove();
	if(data.status !== "ok") {
		console.log("Bad response from /search!")
	} else {
		var index = 0;
		data.results.forEach(function(entry) {
			$('#resultsTable').append(generateRow(entry, index));
			index++;
		})
	}
}

// When the query textbox is changed, make a request to
// /query
$('#query').change(function(){
	var query = $(this).val();
	if(query.length > 0) {
		$('#resultsTable').find("tr").remove();
		$('#resultsTable').append("<tr><td>Loading...<td></tr>")
		$.getJSON("/search", {q: query}, renderResults);
	}
});

function addToJenkinsCallback(data) {
	console.log(data)
}

// "Add to Jenkins" buttons
$(document).on('click', '.add-to-jenkins', function() {
	var index = $(this).attr("data-id");
	var entry = curResults[index];
	var requestData = {
		name: entry.name,
		github_url: entry.url,
		git_url: entry.git_url
	};
	$.post("/createJob", requestData, addToJenkinsCallback, "json");
})

//debug
$('#query').val("redis");
$('#query').change();