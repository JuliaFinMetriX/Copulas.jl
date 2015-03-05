function treeChart() {
    
    var width = 200;
    var height = 500;
    var vSpace = 100;
    var nodeRadius = 12;
    
    function treeChartInner(selection) {
        
        selection.each(function(data){
            
            
            // define margins
            var margin = {top: 20, right: 10, bottom: 30, left: 10};
            
            
            // graphics size without axis
            var innerWidth = width - margin.left - margin.right;
            var innerHeight = height - margin.top - margin.bottom;
            
            var svg = d3.select(this).append("svg")
                .attr("width", innerWidth + margin.left + margin.right)
                .attr("height", innerHeight + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            
            // process data
            var dataMap = data.reduce(function(map, node) {
                map[node.name] = node;
                return map;
            }, {});
            
            var treeData = [];
            data.forEach(function(node) {
                // add to parent
                var parent = dataMap[node.parent];
                if (parent) {
                    // create child array if it doesn't exist
                    (parent.copulaLink || (parent.copulaLink = []))
                    // add node to child array
                        .push(node);
                } else {
                    // parent is null or missing
                    treeData.push(node);
                }
            });
            
            // 
            var tree = d3.layout.tree()
                .sort(function comparator(a, b) {
                    return +a.name - +b.name;
                })
                .size([innerWidth, innerHeight])
                .children(function(d)
                          {
                              return (!d.copulaLink || d.copulaLink.length === 0) ? null : d.copulaLink;
                          });
            
            var nodes = tree.nodes(treeData[0]);
            var links = tree.links(nodes);
            
            nodes.forEach(function(d) { d.y = d.depth * vSpace; });
            
            var link = d3.svg.diagonal()
                .projection(function(d)
                            {
                                return [d.x, d.y];
                            });
            
            svg.selectAll("path.link")
                .data(links)
                .enter()
                .append("svg:path")
                .attr("class", "link")
                .attr("fill", "none")
                .attr("stroke", "#ccc")
                .attr("stroke-width", "2px")
                .attr("d", link);
            
            var nodeGroup = svg.selectAll("g.node")
                .data(nodes)
                .enter()
                .append("svg:g")
                .attr("class", "node")
                .attr("transform", function(d)
                      {
                          return "translate(" + d.x + "," + d.y + ")";
                      });
            
            nodeGroup.append("svg:circle")
                .attr("class", "node-dot")
                .attr("fill", "#fff")
                .attr("stroke", "steelblue")
                .attr("stroke-width", "3px")
                .attr("r", nodeRadius)
            
            nodeGroup.append("svg:text")
                .attr("text-anchor", "middle")
                .attr("alignment-baseline", "central")
                .text(function(d) { return d.name; })
                .style("font-size", "14px")
                .style("font", "sans-serif");
        })
            }
    
    treeChartInner.width = function(value) {
        if (!arguments.length) return width;
        width = value;
        return treeChartInner;
    };
    
    treeChartInner.height = function(value) {
        if (!arguments.length) return height;
        height = value;
        return treeChartInner;
    };
    
    treeChartInner.vSpace = function(value) {
        if (!arguments.length) return vSpace;
        vSpace = value;
        return treeChartInner;
    };
    
    treeChartInner.nodeRadius = function(value) {
        if (!arguments.length) return nodeRadius;
        nodeRadius = value;
        return treeChartInner;
    };
    
    return treeChartInner;
}
