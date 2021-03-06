import React from "react";
import cn from "classnames";
import { connect } from "react-redux";
import { Dispatch } from "redux";
import { ICombinedReducersState } from "../../reducers";
import { ITabs } from "../../reducers/details";
import { activateTab } from "../../actions/details-actions";
import Region from "../details-region";
import Unit from "../details-unit";
import Events from "./events";
import Battles from "./battles";
import { IDetailsProps } from "./details.d";
import "./styles/index.scss";

interface IDetailsItem {
  tabName: ITabs;
  text: string;
}

const DetailsComponent = (props: IDetailsProps) => {
  const { activeTab } = props;
  const items: IDetailsItem[] = [
    { text: "Region", tabName: "REGION" },
    { text: "Unut", tabName: "UNIT" },
    { text: "Events", tabName: "EVENTS" },
    { text: "Battles", tabName: "BATTLES" }
  ];

  return (
    <div className="details-block">
      <div className="row">
        <div className="col-12">
          <ul className="nav nav-tabs">{items.map(item => renderMenuItem(props, item))}</ul>
        </div>
      </div>
      <div className="row details-block__details">
        <div className="col-12 h-100per">
          <div className="card details-block__details-subcontainer">{renderDetails(activeTab)}</div>
        </div>
      </div>
    </div>
  );
};

function renderMenuItem(props: IDetailsProps, item: IDetailsItem) {
  const { onActivateTab, activeTab } = props;

  return (
    <li className="nav-item" key={item.tabName}>
      <a
        className={cn("nav-link", "details-block__link", { active: activeTab === item.tabName })}
        onClick={() => onActivateTab(item.tabName)}
        href="#"
      >
        {item.text}
      </a>
    </li>
  );
}

function renderDetails(activeTab: ITabs) {
  switch (activeTab) {
    case "REGION":
      return <Region />;
    case "UNIT":
      return <Unit />;
    case "EVENTS":
      return <Events />;
    case "BATTLES":
      return <Battles />;
  }
}

const mapStateToProps = (state: ICombinedReducersState) => {
  return {
    activeTab: state.details.activeTab
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return {
    onActivateTab: (tabName: ITabs) => dispatch(activateTab(tabName))
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(DetailsComponent);
