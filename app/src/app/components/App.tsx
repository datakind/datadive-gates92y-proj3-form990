import * as React from 'react';
import * as _ from 'lodash';
import { Map } from 'immutable';
import axios from 'axios';
import * as firebase from 'firebase';
import { Filter } from './Filter';

interface Organization {
    name: string;
    website: string;
    mission: string;
    yearOfFormation: number;
    state: string;
    city: string;
    ntee: string;
}

interface AppState {
    filters: Map<string, any>;
    data: any[];
    selectedFilters: Map<string, string>;
}

export class App extends React.Component<undefined, AppState> {

    constructor() {
        super();

        this.state = {
            filters: Map<string, any>(),
            selectedFilters: Map<string, string>(),
            data: []
        };

        this._handleApply = this._handleApply.bind(this);
        this._handleOptionChange = this._handleOptionChange.bind(this);
    }

    componentDidMount() {
        axios.get('filters').then(results => {
            var filters = Map<string, any>(_.map(results.data.filters, (options, filterName) => {
                return [filterName, options];
            }));
            let firstState = filters.get('state')[0];
            let firstCity = filters.get('city')[firstState][0];
            // let firstNtee = filters.get('ntee')[0];
            let selectedFilters = Map<string, string>([['state', firstState], ['city', firstCity]]);
            this.setState({ ...this.state, filters, selectedFilters });
        });
    }

    render() {
        let states = this.state.filters.get('state', []);
        let state = this.state.selectedFilters.get('state');
        let cities = state && this.state.filters.get('city')[state] || [];

        return (
            <div className="app">
                <h2>Find a Match!</h2>
                <div className="filters">
                    <Filter label="State" options={states} handleOptionChange={this._handleOptionChange.bind(this, 'state')} />
                    {state && <Filter label="City" options={cities} handleOptionChange={this._handleOptionChange.bind(this, 'city')} />}
                    {/* <Filter label="NTEE" options={this.state.filters.get('ntee')} handleOptionChange={this._handleOptionChange.bind(this, 'ntee')} />
                    <Filter label="NTEE Subgroup" options={this.state.subgroups.get(this.state.selectedMajorGroup)} handleOptionChange={this._handleOptionChange.bind(this, 'nteesub')} /> */}
                </div>
                <button className="apply-btn" onClick={this._handleApply}>Apply</button>
                <table className="data-table">
                    <thead>
                        <tr><th>Name</th><th>Mission</th><th>Year of Formation</th><th>City</th><th>State</th><th>NTEE</th></tr>
                    </thead>
                    <tbody>
                        {this.state.data.map(d => {
                            return (<tr>
                                <td>{this._renderName(d.NAME, d.WEBSITE)}</td>
                                <td>{d.MISSION}</td>
                                <td>{d.FORMYEAR}</td>
                                <td>{d.CITY}</td>
                                <td>{d.STATE}</td>
                                <td>{d.NteeFinal}</td>
                            </tr>);
                        })}
                    </tbody>
                </table>
            </div>
        );
    }

    _renderName(name: string, website: string): JSX.Element {
        if (website === 'N/A' || website === 'NA') {
            return <span>{name}</span>;
        }

        let url = website.startsWith('http://') ? website : `http://${website}`;
        return <a href={url} target="_blank">{name}</a>;
    }

    _handleOptionChange(filter: string, value: string) {
        var newSelectedFilters = this.state.selectedFilters.set(filter, value);
        if (filter === 'state') {
            newSelectedFilters = newSelectedFilters.set('city', this.state.filters.get('city')[value][0]);
        }
        this.setState({ ...this.state, selectedFilters: newSelectedFilters });
    }

    _handleApply() {
        var params = this.state.selectedFilters.toObject();
        axios.get('data', { params })
            .then(results => {
                this.setState({ ...this.state, data: results.data });
            });
    }
}
