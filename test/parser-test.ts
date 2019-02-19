import { parseReport } from "../static/javascript/parser";
import "mocha";
import { expect } from "chai";
import { readFile } from "fs";

describe("parseReport", () => {
  it("should work", () => {
    readFile("./test/test-reports/report.rep", "utf8", (err: any, contents: string) => {
      console.log(contents);
    });
    expect(1).to.be.equal(1);
  });
});
