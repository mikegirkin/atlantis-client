import { parseReport } from "../static/javascript/parser";
import "mocha";
import { expect } from "chai";
import { readFile } from "fs";
import { diff } from "deep-diff";

describe("parseReport", () => {
  it("should work", () => {
    readFile("./test/test-reports/report-1.rep", "utf8", (err: any, contents: string) => {
      //console.log(contents);
      let result = parseReport(contents);
      console.log(result);

      expect(1).to.be.equal(1);
    });
  });
});
